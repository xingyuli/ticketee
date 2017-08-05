require 'rails_helper'

RSpec.describe '/api/v1/projects', type: :api do

  let(:user) { FactoryGirl.create(:user) }
  let(:token) { user.authentication_token }
  let(:project) { FactoryGirl.create(:project) }

  before do
    user.permissions.create!(action: 'view', thing: project)
  end

  context 'projects viewable by this user' do
    let(:url) { '/api/v1/projects' }

    before do
      FactoryGirl.create(:project, name: 'Access Denied')
    end

    it 'JSON' do
      get "#{url}.json", token: token

      projects_json = Project.for(user).all.to_json
      expect(last_response.status).to eql(200)
      expect(last_response.body).to eql(projects_json)

      projects = JSON.parse(last_response.body)
      expect(projects.any? { |p| p['name'] == project.name }).to be_truthy
      expect(projects.any? { |p| p['name'] == 'Access Denied' }).to be_falsey
    end

    it 'XML' do
      get "#{url}.xml", token: token
      expect(last_response.body).to eql(Project.for(user).to_xml)

      projects = Nokogiri::XML(last_response.body)
      expect(projects.css('project name').text).to eql(project.name)
    end
  end

  context 'creating a project' do
    let(:url) { '/api/v1/projects' }

    before do
      user.admin = true
      user.save
    end

    it 'successful JSON' do
      post "#{url}.json", token: token, project: { name: 'Inspector' }
      project = Project.find_by_name!('Inspector')

      expect(last_response.status).to eql(201)
      expect(last_response.headers['Location']).to eql("/api/v1/projects/#{project.id}")
      expect(last_response.body).to eql(project.to_json)
    end

    it 'unsuccessful JSON' do
      post "#{url}.json", token: token, project: { name: '' }

      expect(last_response.status).to eql(422)

      errors = {
        'errors': {
          'name': ["can't be blank"]
        }
      }.to_json
      expect(last_response.body).to eql(errors)
    end
  end

  context 'show' do
    let(:url) { "/api/v1/projects/#{project.id}" }

    before do
      FactoryGirl.create(:ticket, user: user, project: project)
    end

    it 'JSON' do
      get "#{url}.json", token: token
      project_json = project.to_json(methods: 'last_ticket')
      expect(last_response.status).to eql(200)
      expect(last_response.body).to eql(project_json)

      project_response = JSON.parse(last_response.body)
      expect(project_response['last_ticket']['title']).not_to be_blank
    end
  end

  context 'updating a project' do

    before do
      user.admin = true
      user.save
    end

    let(:url) { "/api/v1/projects/#{project.id}" }

    it 'successful JSON' do
      put "#{url}.json", token: user.authentication_token, project: { name: 'Not Ticketee' }

      expect(last_response.status).to eql(204)
      expect(last_response.body).to eql('')

      project.reload
      expect(project.name).to eql('Not Ticketee')
    end

    it 'unsuccessful JSON' do
      put "#{url}.json", token: user.authentication_token, project: { name: '' }

      expect(last_response.status).to eql(422)

      errors = { 'errors': { 'name': ["can't be blank"] } }
      expect(last_response.body).to eql(errors.to_json)
    end
  end

end
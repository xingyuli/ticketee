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

    it 'json' do
      get "#{url}.json", token: token

      projects_json = Project.for(user).all.to_json
      expect(last_response.body).to eql(projects_json)
      expect(last_response.status).to eql(200)

      projects = JSON.parse(last_response.body)
      expect(projects.any? { |p| p['name'] == project.name }).to be_truthy
      expect(projects.any? { |p| p['name'] == 'Access Denied' }).to be_falsey
    end
  end

end
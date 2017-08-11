require 'rails_helper'

RSpec.describe '/api/v2/tickets', type: :api do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project, name: 'Ticketee') }
  let(:token) { user.authentication_token }

  before do
    user.permissions.create!(action: 'view', thing: project)
  end

  context 'index' do
    before do
      5.times do
        FactoryGirl.create(:ticket, user: user, project: project)
      end
    end

    let(:url) { "/api/v2/projects/#{project.id}/tickets" }

    it 'JSON' do
      get "#{url}.json", token: token
      expect(last_response.status).to eql(200)
      expect(last_response.body).to eql(project.tickets.to_json)
    end

    it 'XML' do
      get "#{url}.xml", token: token
      expect(last_response.status).to eql(200)
      expect(last_response.body).to eql(project.tickets.to_xml)
    end
  end

  context 'pagination' do
    before do
      3.times { FactoryGirl.create(:ticket, user: user, project: project) }

      @default_per_page = Kaminari.config.default_per_page
      Kaminari.config.default_per_page = 1
    end

    after do
      Kaminari.config.default_per_page = @default_per_page
    end

    it 'gets the first page' do
      get "/api/v2/projects/#{project.id}/tickets.json", token: token, page: 1
      expect(last_response.body).to eql(project.tickets.page(1).to_json)
    end

    it 'gets the second page' do
      get "/api/v2/projects/#{project.id}/tickets.json", token: token, page: 2
      expect(last_response.body).to eql(project.tickets.page(2).to_json)
    end
  end

end
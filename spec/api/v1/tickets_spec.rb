require 'rails_helper'

RSpec.describe '/api/v1/tickets', type: :api do

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

    let(:url) { "/api/v1/projects/#{project.id}/tickets" }

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

end
require 'rails_helper'

RSpec.describe FilesController, type: :controller do

  let(:good_user) { FactoryGirl.create(:user) }
  let(:bad_user) { FactoryGirl.create(:user) }

  let(:project) { FactoryGirl.create(:project) }
  let(:ticket) { FactoryGirl.create(:ticket, user: good_user, project: project) }

  let(:path) { Rails.root + 'spec/fixtures/speed.txt' }
  let(:asset) {
    ticket.assets.create(asset: File.open(path))
  }

  before do
    define_permission!(good_user, 'view', project)
  end

  context 'users with access' do
    before do
      sign_in(good_user)
    end
    it 'can access assets in a project' do
      get :show, params: { id: asset.id }
      expect(response.body).to eql(File.read(path))
    end
  end

  context 'users without access' do
    before do
      sign_in(bad_user)
    end
    it 'cannot access assets in this project' do
      get :show, params: { id: asset.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eql('The asset you were looking for could not be found.')
    end
  end

end

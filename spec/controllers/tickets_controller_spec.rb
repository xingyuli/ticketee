require 'rails_helper'

RSpec.describe TicketsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:ticket) { FactoryGirl.create(:ticket, user: user, project: project) }

  context 'standard users' do
    it 'cannot access a ticket for a project' do
      sign_in(user)

      get :show, params: { :project_id => project.id, :id => ticket.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eql('The project you were looking for could not be found.')
    end
  end

  context 'with permission to view the project' do
    before do
      sign_in(user)
      define_permission!(user, :view, project)
    end

    def cannot_create_tickets!
      expect(response).to redirect_to(project)
      expect(flash[:alert]).to eql('You cannot create tickets on this project.')
    end

    def cannot_update_tickets!
      expect(response).to redirect_to(project)
      expect(flash[:alert]).to eql('You cannot edit tickets on this project.')
    end

    it 'cannot begin to create a ticket' do
      get :new, params: { :project_id => project.id }
      cannot_create_tickets!
    end

    it 'cannot create a ticket without permission' do
      post :create, params: { :project_id => project.id }
      cannot_create_tickets!
    end

    it 'cannot edit a ticket without permission' do
      get :edit, params: { :project_id => project.id, :id => ticket.id }
      cannot_update_tickets!
    end

    it 'cannot update a ticket without permission' do
      post :update, params: { :project_id => project.id, :id => ticket.id, :ticket => {} }
      cannot_update_tickets!
    end

    it 'cannot delete a ticket without permission' do
      delete :destroy, params: { :project_id => project.id, :id => ticket.id }

      expect(response).to redirect_to(project)
      expect(flash[:alert]).to eql('You cannot delete tickets on this project.')
    end

    it 'can create tickets, but not tag them' do
      define_permission!(user, 'create tickets', project)

      post :create, params: {
        :ticket => {
          :title => 'New ticket!',
          :description => "Brand spankin' new",
          :tag_names => 'these are tags'
        },
        :project_id => project.id }

      expect(Ticket.last.tags).to be_empty
    end
  end

end

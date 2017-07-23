require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, name: 'Ticketee') }

  let(:ticket) { FactoryGirl.create(:ticket,
                                    title: 'State transitions',
                                    description: "Can't be hacked.",
                                    project: project,
                                    user: user) }

  let(:state) { FactoryGirl.create(:state, name: 'New') }

  context 'a user withouth permission to set state' do
    before do
      sign_in(user)
    end

    it 'cannot transition a state by passing through state_id' do
      post :create, params: {
        :comment => {
          :text => 'Hacked!', :state_id => state.id
        },
        :ticket_id => ticket.id
      }
      ticket.reload
      expect(ticket.state).to eql(nil)
    end
  end

end

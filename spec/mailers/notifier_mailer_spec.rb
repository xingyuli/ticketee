require 'rails_helper'

describe NotifierMailer do

  context 'comment updated' do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:ticker_owner) { FactoryGirl.create(:user) }
    let!(:ticket) { FactoryGirl.create(:ticket, user: ticker_owner, project: project) }
    let!(:commenter) { FactoryGirl.create(:user) }
    let!(:comment) { FactoryGirl.create(:comment, text: 'Test comment', ticket: ticket, user: commenter) }

    let(:email) do
      NotifierMailer.comment_updated(comment, ticker_owner)
    end

    it 'sends out an email notification about a new comment' do
      expect(email.to).to include(ticker_owner.email)
      title = "#{ticket.title} for #{project.name} has been updated."
      expect(email.body).to include(title)
      expect(email.body).to include("#{comment.user.email} wrote:")
      expect(email.body).to include(comment.text)
    end
  end

end
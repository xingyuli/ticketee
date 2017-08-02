require 'rails_helper'

feature 'QQExMail' do
  let!(:alice) { FactoryGirl.create(:user) }
  let!(:me) { FactoryGirl.create(:user, email: 'xingyu.liu@mobisist.com') }

  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, user: me, project: project) }

  before do
    ActionMailer::Base.delivery_method = :smtp
    define_permission!(alice, :view, project)
    define_permission!(me, :view, project)
  end

  after do
    ActionMailer::Base.delivery_method = :test
  end

  # scenario 'Receiving a real-world email' do
  #   sign_in_as!(alice)
  #   visit project_ticket_path(project, ticket)
  #   fill_in 'comment_text', with: 'Posting a comment1'
  #   click_button 'Create Comment'
  #   expect(page).to have_content('Comment has been created.')
  #
  #   expect(ticketee_emails.count).to eql(1)
  #   email = ticketee_emails.first
  #   expect(email.subject).to eql("[ticketee] #{project.name} - #{ticket.title}")
  #   clear_ticketee_emails!
  # end

end
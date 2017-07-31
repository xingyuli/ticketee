require 'rails_helper'

feature 'Ticket Notifications' do

  let!(:alice) { FactoryGirl.create(:user, name: 'Alice', email: 'alice@example.com') }
  let!(:bob) { FactoryGirl.create(:user, name: 'Bob', email: 'bob@example.com') }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, user: alice, project: project) }

  before do
    ActionMailer::Base.deliveries.clear

    define_permission!(alice, :view, project)
    define_permission!(bob, :view, project)

    sign_in_as!(bob)
    visit '/'
  end

  scenario 'Ticket owner receives notifications about comments' do
    click_link project.name
    click_link ticket.title
    fill_in 'comment_text', with: 'Is it out yet?'
    click_button 'Create Comment'

    email = find_email!(alice.email)
    subject = "[ticketee] #{project.name} - #{ticket.title}"
    expect(email.subject).to include(subject)
    click_first_link_in_email(email)

    within('#ticket h2') do
      expect(page).to have_content(ticket.title)
    end
  end

end
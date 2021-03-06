require 'rails_helper'

feature 'Seed Data' do
  scenario 'The basic' do
    load Rails.root + 'db/seeds.rb'
    user = User.find_by_email!('admin@example.com')
    user.password = 'password' # find method didn't return password!

    sign_in_as!(user)
    click_link 'Ticketee Beta'
    click_link 'New Ticket'
    fill_in 'Title', with: 'Comments with state'
    fill_in 'Description', with: 'Comments always have a state.'
    click_button 'Create Ticket'
    within('#comment_state_id') do
      expect(page).to have_content('New')
      expect(page).to have_content('Open')
      expect(page).to have_content('Closed')
    end
  end
end
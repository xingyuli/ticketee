require 'rails_helper'

feature 'Creating projects' do
  scenario 'can create a project' do
    visit '/'
    click_link 'New Project'
    # Find input by corresponding label
    fill_in 'Name', with: 'TextMate 2'
    # Find input by id
    fill_in 'project_description', with: 'A text-editor for OS X'
    click_button 'Create Project'
    expect(page).to have_content('Project has been created.')
  end
end

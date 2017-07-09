require 'rails_helper'

feature 'Creating projects' do

  before do
    sign_in_as!(FactoryGirl.create(:admin_user))

    visit '/'
    click_link 'New Project'
  end

  scenario 'can create a project' do
    # Find input by corresponding label
    fill_in 'Name', with: 'TextMate 2'
    # Find input by id
    fill_in 'project_description', with: 'A text-editor for OS X'
    click_button 'Create Project'
    expect(page).to have_content('Project has been created.')

    project = Project.where(name: 'TextMate 2').first
    expect(page.current_url).to eql(project_url(project))
    title = 'TextMate 2 - Projects - Ticketee'
    expect(page).to have_title(title)
  end

  scenario 'can not create a project without a name' do
    click_button 'Create Project'

    expect(page).to have_content('Project has not been created.')
    expect(page).to have_content("Name can't be blank")
  end

end

require 'rails_helper'

feature 'Assigning permissions' do

  let!(:admin) { FactoryGirl.create(:admin_user) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, user: user, project: project) }

  before do
    sign_in_as!(admin)

    click_link 'Admin'
    click_link 'Users'
    click_link user.email
    click_link 'Permissions'
  end

  scenario 'Viewing a project' do
    check_permission_box 'view', project

    click_button 'Update'
    click_link 'Sign Out'

    sign_in_as!(user)
    expect(page).to have_content(project.name)
  end

end
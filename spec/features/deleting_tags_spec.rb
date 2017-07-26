require 'rails_helper'

feature 'Deleting tags' do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }

  let!(:ticket) { FactoryGirl.create(:ticket,
                                     project: project,
                                     user: user,
                                     tag_names: 'this-tag-must-die') }

  before do
    sign_in_as!(user)
    define_permission!(user, :view, project)
    define_permission!(user, :tag, project)

    visit '/'
    click_link project.name
    click_link ticket.title
  end

  scenario 'Deleting a tag', js: true do
    click_link 'delete-this-tag-must-die'
    within('#ticket #tags') do
      expect(page).not_to have_content('this-tag-must-die')
    end
  end

end
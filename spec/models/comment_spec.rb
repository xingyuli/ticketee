require 'rails_helper'

RSpec.describe Comment, type: :model do

  let(:user) { FactoryGirl.create(:user) }
  let(:commenter) { FactoryGirl.create(:user) }

  before do
    project = FactoryGirl.create(:project)
    @ticket = FactoryGirl.create(:ticket, user: user, project: project)
  end

  it 'notifies people through a delayed job' do
    expect(Delayed::Job.count).to eql(0)
    @ticket.comments.create!(text: 'This is a comment', user: commenter)
    expect(Delayed::Job.count).to eql(1)

    Delayed::Worker.new.work_off(1)
    expect(Delayed::Job.count).to eql(0)

    email = ActionMailer::Base.deliveries.last
    # NOTE email.to.class is Mail::AddressContainer, subclass of Array
    expect(email.to.first).to eql(user.email)
  end

end
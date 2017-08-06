require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'passwords' do
    it 'needs a password and confirmation to save' do
      u = User.new(name: 'steve', email: 'steve@example.com')

      u.save
      expect(u).not_to be_valid

      u.password = 'password'
      u.password_confirmation = ''
      u.save
      expect(u).not_to be_valid

      u.password_confirmation = 'password'
      u.save
      expect(u).to be_valid
    end

    it 'needs password and confirmation to match' do
      u = User.create(name: 'steve',
                      password: 'hunter2',
                      password_confirmation: 'hunter')

      expect(u).not_to be_valid
    end
  end

  describe 'authentication' do
    let!(:user) {
      User.create(name: 'steve',
                  password: 'hunter2',
                  password_confirmation: 'hunter2'
      )
    }

    it 'authenticates with a correct password' do
      expect(user.authenticate('hunter2')).to be
    end

    it 'does not authenticate with an incorrect password' do
      expect(user.authenticate('')).not_to be
    end
  end

  it 'requires an email' do
    u = User.new(name: 'steve',
                 password: 'hunter2',
                 password_confirmation: 'hunter2')
    u.save
    expect(u).to_not be_valid

    u.email = 'steve@example.com'
    u.save
    expect(u).to be_valid
  end

  it 'resets user request count' do
    u = FactoryGirl.create(:user)
    u.update_attribute(:request_count, 42)
    User.reset_request_count!
    u.reload
    expect(u.request_count).to eql(0)
  end

end

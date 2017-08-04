class User < ApplicationRecord
  before_save :ensure_authentication_token

  validates :email, presence: true

  has_secure_password

  has_many :permissions

  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end

  private

  def ensure_authentication_token
    # TODO implements this by making use of appropriate gem
  end

end

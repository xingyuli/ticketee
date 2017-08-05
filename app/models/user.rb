require 'jwt'

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
    unless authentication_token
      payload = { sub: email, exp: Time.now.to_i + 3 * 24 * 3600 }
      token = JWT.encode(payload, Rails.application.secrets.hmac_secret, 'HS256')
      self.authentication_token = token
    end
  end

end

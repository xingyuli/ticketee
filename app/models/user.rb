class User < ApplicationRecord
  has_secure_password

  has_many :permissions

  validates :email, presence: true

  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end
end

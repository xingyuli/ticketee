class Ticket < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  belongs_to :project
  belongs_to :state, optional: true
  belongs_to :user
  has_many :assets
  has_many :comments

  accepts_nested_attributes_for :assets
end

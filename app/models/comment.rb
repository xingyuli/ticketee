class Comment < ApplicationRecord
  validates :text, presence: true

  belongs_to :ticket
  belongs_to :user
end

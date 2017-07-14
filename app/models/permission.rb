class Permission < ApplicationRecord
  belongs_to :user
  belongs_to :thing, polymorphic: true
end

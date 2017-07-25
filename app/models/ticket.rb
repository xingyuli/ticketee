class Ticket < ApplicationRecord
  before_create :associate_tags

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  belongs_to :project
  belongs_to :state, optional: true
  belongs_to :user
  has_many :assets
  has_many :comments
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :assets

  attr_accessor :tag_names

  private

  def associate_tags
    if tag_names
      tag_names.split(' ').each do |name|
        tags << Tag.find_or_create_by(name: name)
      end
    end
  end

end

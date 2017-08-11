class Comment < ApplicationRecord
  before_create :set_previous_state
  after_create :set_ticket_state
  after_create :associate_tags_with_ticket
  after_create :send_mail_to_watchers
  after_create :creator_watches_ticket

  delegate :project, to: :ticket

  validates :text, presence: true

  belongs_to :ticket
  belongs_to :user
  belongs_to :previous_state, optional: true, class_name: 'State'
  belongs_to :state, optional: true

  attr_accessor :tag_names

  private

  def set_previous_state
    self.previous_state = ticket.state
  end

  def set_ticket_state
    ticket.state = state
    ticket.save!
  end

  def associate_tags_with_ticket
    if tag_names
      tags = tag_names.split(' ').map { |name| Tag.find_or_create_by(name: name) }
      ticket.tags += tags
      ticket.save
    end
  end

  def send_mail_to_watchers
    Delayed::Job.enqueue CommentNotifierJob.new(id)
  end

  def creator_watches_ticket
    ticket.watchers << user unless ticket.watchers.include?(user)
  end

end

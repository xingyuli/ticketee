class Comment < ApplicationRecord
  before_create :set_previous_state
  after_create :set_ticket_state

  delegate :project, to: :ticket

  belongs_to :ticket
  belongs_to :user
  belongs_to :previous_state, class_name: 'State', optional: true
  belongs_to :state

  validates :text, presence: true

  private

  def set_previous_state
    self.previous_state = ticket.state
  end

  def set_ticket_state
    ticket.state = state
    ticket.save!
  end

end

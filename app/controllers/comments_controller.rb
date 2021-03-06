class CommentsController < ApplicationController

  before_action :require_signin!
  before_action :set_ticket

  def create
    @comment = @ticket.comments.build(ticket_params)
    @comment.user = current_user
    if @comment.save
      redirect_to [@ticket.project, @ticket], notice: 'Comment has been created.'
    else
      flash[:alert] = 'Comment has not been created.'
      render 'tickets/show'
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def ticket_params
    if cannot?(:'change states', @ticket.project)
      params[:comment].delete(:state_id)
    end
    if cannot?(:tag, @ticket.project)
      params[:comment].delete(:tag_names)
    end
    params.require(:comment).permit(:text, :state_id, :tag_names)
  end

end

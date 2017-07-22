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
    params.require(:comment).permit(:text, :state_id)
  end

end

class TicketsController < ApplicationController

  before_action :require_signin!
  before_action :set_project
  before_action :set_ticket, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_create!, only: [ :new, :create ]

  def show
  end

  def new
    @ticket = @project.tickets.build
  end

  def edit
  end

  def create
    @ticket = @project.tickets.build(ticket_params)
    @ticket.user = current_user
    if @ticket.save
      redirect_to [ @project, @ticket ], notice: 'Ticket has been created.'
    else
      flash[:alert] = 'Ticket has not been created.'
      render 'new'
    end
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to [ @project, @ticket ], notice: 'Ticket has been updated.'
    else
      flash[:alert] = 'Ticket has not been updated.'
      render 'edit'
    end
  end

  def destroy
    @ticket.destroy
    redirect_to @project, notice: 'Ticket has been destroyed.'
  end

  private

  def set_project
    @project = Project.for(current_user).find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'The project you were looking for could not be found.'
  end

  def set_ticket
    @ticket = @project.tickets.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description)
  end

  def authorize_create!
    if !current_user.admin? && cannot?('create tickets'.to_sym, @project)
      redirect_to @project, alert: 'You cannot create tickets on this project.'
    end
  end

end

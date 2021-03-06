class TicketsController < ApplicationController

  before_action :require_signin!
  before_action :set_project
  before_action :set_ticket, only: [ :show, :edit, :update, :destroy, :watch ]
  before_action :authorize_create!, only: [ :new, :create ]
  before_action :authorize_update!, only: [ :edit, :update ]
  before_action :authorize_delete!, only: :destroy

  def show
    @comment = @ticket.comments.build
  end

  def new
    @ticket = @project.tickets.build
    @ticket.assets.build
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

  def watch
    if @ticket.watchers.exists?(current_user.id)
      @ticket.watchers -= [current_user]
      flash[:notice] = 'You are no longer watching this ticket.'
    else
      @ticket.watchers << current_user
      flash[:notice] = 'You are now watching this ticket.'
    end

    redirect_to project_ticket_path(@project, @ticket)
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
    if cannot?(:tag, @project)
      params[:ticket].delete(:tag_names)
    end
    params.require(:ticket).permit(:title, :description, :tag_names, assets_attributes: [:asset])
  end

  def authorize_create!
    if !current_user.admin? && cannot?('create tickets'.to_sym, @project)
      redirect_to @project, alert: 'You cannot create tickets on this project.'
    end
  end

  def authorize_update!
    if !current_user.admin? && cannot?('edit tickets'.to_sym, @project)
      redirect_to @project, alert: 'You cannot edit tickets on this project.'
    end
  end

  def authorize_delete!
    if !current_user.admin? && cannot?('delete tickets'.to_sym, @project)
      redirect_to @project, alert: 'You cannot delete tickets on this project.'
    end
  end

end

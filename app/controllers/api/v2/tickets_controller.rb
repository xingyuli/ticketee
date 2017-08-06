class Api::V2::TicketsController < Api::V2::BaseController

  before_action :set_project

  def index
    respond_with @project.tickets
  end

  private

  def set_project
    begin
      @project = Project.for(current_user).find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      error = { error: 'The project you were looking for could not be found.' }
      render params[:format].to_sym => error, status: 404
    end
  end

end
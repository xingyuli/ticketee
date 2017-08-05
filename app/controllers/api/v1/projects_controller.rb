class Api::V1::ProjectsController < Api::V1::BaseController

  before_action :authorize_admin!, except: [ :index, :show ]
  before_action :set_project, only: [:show, :update, :destroy]

  def index
    respond_with Project.for(current_user).all
  end

  def show
    respond_with @project, methods: 'last_ticket'
  end

  def create
    project = Project.new(project_params)
    if project.save
      respond_with project, location: api_v1_project_path(project)
    else
      respond_with project
    end
  end

  def update
    @project.update(project_params)
    respond_with @project
  end

  def destroy
    @project.destroy
    respond_with @project
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def set_project
    begin
      @project = Project.for(current_user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error = { error: 'The project you were looking for could not be found.' }
      render params[:format].to_sym => error, status: 404
    end
  end

end
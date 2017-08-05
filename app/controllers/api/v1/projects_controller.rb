class Api::V1::ProjectsController < Api::V1::BaseController

  before_action :authorize_admin!, except: [ :index, :show ]

  def index
    respond_with Project.for(current_user).all
  end

  # def show
  #   @project = Project.find(params[:id])
  #   puts @project.class.superclass
  #   puts @project.to_xml
  #   respond_with @project
  # end

  def create
    project = Project.new(project_params)
    if project.save
      respond_with project, location: api_v1_project_path(project)
    else
      respond_with project
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

end
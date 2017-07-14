class ProjectsController < ApplicationController

  before_action :authorize_admin!, except: [ :index, :show ]
  before_action :require_signin!, only: [ :index, :show ]
  before_action :set_project, only: [ :show, :edit, :update, :destroy ]

  def index
    @projects = Project.for(current_user)
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, notice: 'Project has been created.'
    else
      flash[:alert] = 'Project has not been created.'
      render 'new'
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project has been updated.'
    else
      flash[:alert] = 'Project has not been updated.'
      render 'edit'
    end
  end

  def destroy
    @project.destroy

    redirect_to projects_path, notice: 'Project has been destroyed.'
  end

  private

  def set_project
    begin
      @project = Project.for(current_user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_path, alert: 'The project you were looking for could not be found.'
    end
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end

end

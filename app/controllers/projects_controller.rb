class ProjectsController < ApplicationController
  def index
    @recent_projects = Project.recent_by_user(current_user)
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to projects_path, notice: 'Project was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @project = Project.find_by(id: params[:id])
  end

  def edit
    @project = current_user.projects.find(params[:id])
  end

  def update
    @project = current_user.projects.find(params[:id])

    if @project.update(project_params)
      redirect_to projects_path, notice: 'Project updated'
    else
      flash[:error] = 'Please enter the information correctly'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy
    flash[:notice] = 'The project was deleted'
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :visibility, :design_document, :srs_document)
  end
end

class ProjectsController < ApplicationController
  skip_before_action :require_authorization, only: %i[show search]
  before_action :current_user_project, only: %i[edit update destroy]

  def index
    @recent_projects = Project.recent_by_user(current_user)
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to projects_path, flash: { notice: 'Project was successfully created!' }
    else
      flash.now[:error] = 'Please enter the information correctly'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @project = Project.find_by(id: params[:id])
    @bids = @project.bids
  end

  def edit
    @categories = Category.all
  end

  def update
    if @project.update(project_params)
      if admin?
        redirect_to admin_manage_projects_path, flash: { notice: 'Project was successfully updated!' }
      else
        redirect_to projects_path, flash: { notice: 'Project was successfully updated!' }
      end
    else
      flash.now[:error] = 'Please enter the information correctly'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    if admin?
      redirect_to admin_manage_projects_path, flash: { notice: 'Project was successfully deleted!' }
    else
      redirect_to projects_path, flash: { notice: 'Project was successfully deleted!' }
    end
  end

  def search
    @projects = if params[:search].present?
                  Project.search_projects(params[:search]).records
                else
                  Project.all
                end
  end

  private

  def current_user_project
    @project = if admin?
                 Project.find_by(id: params[:id])
               else
                 current_user.projects.find(params[:id])
               end
  end

  def project_params
    params.require(:project).permit(:title, :description, :visibility, :design_document, :srs_document, skills: [],
                                                                                                        category_ids: [])
  end
end

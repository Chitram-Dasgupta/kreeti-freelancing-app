class ProjectsController < ApplicationController
  skip_before_action :require_authorization, only: %i[show search]
  before_action :current_user_project, only: %i[edit update destroy]

  def index
    if admin?
      @projects = Project.all.order(created_at: :asc)
    else
      @recent_projects = Project.recent_by_user(current_user)
    end
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

    return unless @project.visibility == 'priv' && @project.user != current_user

    redirect_to search_projects_path, flash: { error: 'You don\'t have permission to view this project.' }
  end

  def edit
    @categories = Category.all
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, flash: { notice: 'Project was successfully updated!' }
    else
      flash.now[:error] = 'Please enter the information correctly'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, flash: { notice: 'Project was successfully deleted!' }
  end

  def search
    @projects = if params[:search].present?
                  projects = Project.search_projects(params[:search], params[:filter] != 'unawarded').records
                  params[:filter] == 'unawarded' ? projects.without_awarded_bids : projects
                else
                  params[:filter] == 'unawarded' ? Project.where(visibility: 'pub').without_awarded_bids : Project.where(visibility: 'pub')
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

# frozen_string_literal: true

class ProjectsController < ApplicationController
  skip_before_action :require_authorization, only: %i[show search]
  before_action :set_project, only: %i[edit update destroy]

  def index
    if admin?
      @projects = Project.all.page params[:page]
    elsif client?
      @user_projects = current_user.projects.page params[:page]
    else
      redirect_to root_path, flash: { error: 'You are not authorized to view projects' }
    end
  end

  def show
    @project = Project.find_by(id: params[:id])

    return redirect_to root_path, flash: { error: 'Project cannot be shown' } if @project.nil?

    @bids = @project.bids.where.not(bid_status: 'rejected').page params[:page]
  end

  def new
    return redirect_to root_path, flash: { error: 'Project cannot be created' } unless client?

    @project = current_user.projects.new
  end

  def edit
    if current_user != @project.user && !admin?
      return redirect_to root_path, flash: { error: 'Project cannot be edited' }
    end
    return redirect_to @project, notice: 'Cannot edit an awarded project' if @project.has_awarded_bid?

    @categories = Category.all
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

  def update
    return redirect_to @project, notice: 'Cannot update an awarded project.' if @project.has_awarded_bid?

    if @project.update(project_params)
      redirect_to @project, flash: { notice: 'Project was successfully updated!' }
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
    @projects = Project.search_projects(params[:search]).records.page params[:page]
  end

  private

  def set_project
    @project = Project.find_by(id: params[:id])
    return redirect_to root_path, flash: { error: 'Project not found' } if @project.nil?
  end

  def project_params
    params.require(:project).permit(:title, :description, :design_document, :srs_document,
                                    skills: [], category_ids: [])
  end
end

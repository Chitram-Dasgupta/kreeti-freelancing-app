# frozen_string_literal: true

class ProjectsController < ApplicationController
  skip_before_action :require_authorization, only: %i[show search]
  before_action :current_user_project, only: %i[edit update destroy]

  def index
    if admin?
      @projects = Project.all.page params[:page]
    else
      @user_projects = current_user.projects.page params[:page]
    end
  end

  def show
    @project = Project.visible_to(current_user).find_by(id: params[:id])
    @bids = @project.bids.where.not(bid_status: 'rejected').page params[:page]

    return if @project.present?

    redirect_to search_projects_path, flash: { error: 'You don\'t have permission to view this project.' }
  end

  def new
    @project = current_user.projects.new
  end

  def edit
    redirect_to @project, notice: 'Cannot edit an awarded project' if @project.has_awarded_bid?
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
    redirect_to @project, notice: 'Cannot update an awarded project.' if @project.has_awarded_bid?
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

  def current_user_project
    id_param = params[:id]
    @project = if admin?
                 Project.find_by(id: id_param)
               else
                 current_user.projects.find_by(id: id_param)
               end
  end

  def project_params
    params.require(:project).permit(:title, :description, :visibility, :design_document, :srs_document,
                                    skills: [], category_ids: [])
  end
end

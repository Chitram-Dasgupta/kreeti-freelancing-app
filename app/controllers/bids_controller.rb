# frozen_string_literal: true

class BidsController < ApplicationController
  before_action :check_rejected, only: %i[edit update]
  before_action :set_bid, only: %i[show edit update destroy accept reject files_upload]

  def index
    if admin?
      @bids = Bid.all.order(created_at: :asc)
    else
      @bids = Bid.recent_by_user(current_user)
      @recent_projects = Project.recent
    end
  end

  def show; end

  def new
    @project = Project.find_by(id: params[:project_id])
    @bid = Bid.new
  end

  def edit; end

  def create
    @project = Project.find_by(id: params['bid']['project_id'])
    @bid = Bid.new(bid_params)
    if @bid.save
      redirect_to @bid.project, flash: { success: 'Bid was successfully created' }
    else
      flash.now[:error] = 'Bid could not be created.'
      render 'new', locals: { project: @project }
    end
  end

  def update
    if @bid&.update(bid_params)
      redirect_to bids_path, flash: { success: 'Bid was successfully updated' }
    else
      flash.now[:error] = 'Please enter the information correctly'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bid.destroy
    redirect_to bids_path, flash: { notice: 'Bid was successfully deleted' }
  end

  def accept
    @bid.accept
    redirect_to @bid.project, flash: { notice: 'Bid accepted' }
  end

  def reject
    @bid.reject
    redirect_to @bid.project, flash: { notice: 'Bid rejected' }
  end

  def files_upload
    if @bid.project.completed?
      redirect_to @bid, flash: { error: 'Cannot upload files to a completed project' }
    elsif files_present?
      attach_files
      redirect_to @bid, flash: { success: 'Files uploaded successfully' }
    else
      redirect_to @bid, flash: { error: 'Please upload at least one file' }
    end
  end

  private

  def set_bid
    @bid = if freelancer?
             current_user.bids.find_by(id: params[:id])
           else
             Bid.find_by(id: params[:id])
           end
  end

  def files_present?
    return false if params[:bid].nil?

    [params[:bid][:bid_code_document], params[:bid][:bid_design_document], params[:bid][:bid_other_document]]
      .count(&:present?).positive?
  end

  def attach_files
    @bid.bid_code_document.attach(params[:bid][:bid_code_document])
    @bid.bid_design_document.attach(params[:bid][:bid_design_document])
    @bid.bid_other_document.attach(params[:bid][:bid_other_document])
    @bid.upload_project_files
  end

  def check_rejected
    @bid = Bid.find_by(id: params[:id])
    redirect_to bids_path, flash: { error: 'Bid cannot be modified' } if @bid.rejected?
  end

  def bid_params
    params.require(:bid).permit(:bid_description, :bid_amount, :project_id, :user_id, :bid_code_document,
                                :bid_design_document, :bid_other_document)
  end
end

# frozen_string_literal: true

class BidsController < ApplicationController
  before_action :check_rejected, only: %i[edit update]
  before_action :set_bid, only: %i[show edit update destroy accept reject files_upload]

  def index
    @bids = if admin?
              Bid.all
            else
              current_user.bids
            end
    @bids = @bids.page params[:page]
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
      redirect_to @bid, flash: { success: 'Bid was successfully updated' }
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
    if files_present?
      attach_files
      redirect_to @bid, flash: { success: 'Files uploaded successfully' }
    else
      redirect_to @bid, flash: { error: 'Please upload at least one file' }
    end
  end

  private

  def attach_files
    bid = params[:bid]
    @bid.bid_code_document.attach(bid[:bid_code_document])
    @bid.bid_design_document.attach(bid[:bid_design_document])
    @bid.bid_other_document.attach(bid[:bid_other_document])
    @bid.upload_project_files
  end

  def check_rejected
    @bid = Bid.find_by(id: params[:id])
    redirect_to bids_path, flash: { error: 'Bid cannot be modified' } if @bid.rejected?
  end

  def files_present?
    bid = params[:bid]
    return false if bid.nil?

    [bid[:bid_code_document], bid[:bid_design_document], bid[:bid_other_document]]
      .count(&:present?).positive?
  end

  def set_bid
    @bid = Bid.find_by(id: params[:id])
    redirect_to bids_path, flash: { error: 'Bid not found' } if @bid.nil?
  end

  def bid_params
    params.require(:bid).permit(:bid_description, :bid_amount, :project_id, :user_id, :bid_code_document,
                                :bid_design_document, :bid_other_document)
  end
end

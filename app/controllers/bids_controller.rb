class BidsController < ApplicationController
  before_action :check_rejected_or_awarded, only: %i[edit update]
  before_action :set_bid, only: %i[show edit update destroy accept reject hold award]

  def index
    @recent_bids = Bid.recent_by_user(current_user)
    @recent_projects = Project.recent
  end

  def new
    @project = Project.find(params[:project_id])
    @bid = @project.bids.new
  end

  def create
    @bid = Bid.new(bid_params)
    if @bid.save
      redirect_to @bid.project, flash: { success: 'Bid was successfully created' }
    else
      flash.now[:error] = 'Bid could not be created. Please try again.'
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @bid&.update(bid_params)
      if admin?
        redirect_to admin_manage_bids_path, flash: { success: 'Bid was successfully updated' }
      else
        redirect_to bids_path, flash: { success: 'Bid was successfully updated' }
      end
    else
      flash.now[:error] = 'Please enter the information correctly'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bid.destroy
    if admin?
      redirect_to admin_manage_bids_path, flash: { notice: 'Bid was successfully deleted' }
    else
      redirect_to bids_path, flash: { notice: 'Bid was successfully deleted' }
    end
  end

  def accept
    bid.accept
    redirect_to bid.project, flash: { notice: 'Bid accepted' }
  end

  def reject
    bid.reject
    redirect_to bid.project, flash: { notice: 'Bid rejected' }
  end

  def hold
    bid.hold
    redirect_to bid.project, flash: { notice: 'Bid put on hold' }
  end

  def award
    bid.award
    redirect_to bid.project, flash: { sucess: 'Bid accepted' }
  end

  private

  def set_bid
    @bid = if freelancer?
             current_user.bids.find_by(id: params[:id])
           else
             Bid.find_by(id: params[:id])
           end
  end

  def check_rejected_or_awarded
    @bid = Bid.find_by(id: params[:id])
    redirect_to bids_path, flash: { error: 'Bid cannot be modified' } unless @bid.modifiable?
  end

  def bid_params
    params.require(:bid).permit(:bid_name, :bid_description, :bid_status, :bid_amount, :project_id, :user_id)
  end
end

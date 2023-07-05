class BidsController < ApplicationController
  before_action :check_rejected_or_awarded, only: %i[edit update]
  before_action :set_bid, only: %i[show edit update destroy accept reject hold award]

  def index
    if admin?
      @bids = Bid.all.order(created_at: :asc)
    else
      @recent_bids = Bid.recent_by_user(current_user)
      @recent_projects = Project.recent
    end

  end

  def new
    @project = Project.find_by(id: params[:project_id])
    @bid = Bid.new
  end

  def create
    @project = Project.find_by(id: params['bid']['project_id'])
    @bid = Bid.new(bid_params)
    if @bid.save
      redirect_to @bid.project, flash: { success: 'Bid was successfully created' }
    else
      if @bid.errors.include?(:user_id)
        flash[:error] = @bid.errors.full_messages.to_sentence
      else
        flash.now[:error] = 'Bid could not be created. Please try again.'
      end
      render 'new', locals: { project: @project }
    end
  end

  def show; end

  def edit; end

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

  def hold
    @bid.hold
    redirect_to @bid.project, flash: { notice: 'Bid put on hold' }
  end

  def award
    @bid.award
    redirect_to @bid.project, flash: { sucess: 'Bid awarded' }
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
    params.require(:bid).permit(:bid_name, :bid_description, :bid_amount, :project_id, :user_id)
  end
end

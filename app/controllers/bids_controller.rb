class BidsController < ApplicationController
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
      redirect_to @bid.project, notice: 'Bid was successfully created.'
    else
      render :new
    end
  end

  def show
    @bid = Bid.find_by(id: params[:id])
  end

  def edit
    @bid = Bid.find_by(id: params[:id])
  end

  def update
    @bid = current_user.bids.find(params[:id])

    if @bid&.update(bid_params)
      redirect_to bids_path, notice: 'Bid updated'
    else
      flash[:error] = 'Please enter the information correctly'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bid = Bid.find_by(id: params[:id])
    @bid.destroy
    flash[:notice] = 'The bid was deleted'
    redirect_to bids_path
  end

  private

  def bid_params
    # params.require(:bid).permit(:bid_name, :bid_description, :bid_status, :bid_amount, :bid_code_document, :bid_design_document, :bid_other_document, :project_id, :user_id)
    params.require(:bid).permit(:bid_name, :bid_description, :bid_amount, :project_id, :user_id)
  end
end

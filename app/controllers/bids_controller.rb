class BidsController < ApplicationController
  def index
    @recent_bids = Bid.recent_by_user(current_user)

    @recent_projects = Project.recent
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end

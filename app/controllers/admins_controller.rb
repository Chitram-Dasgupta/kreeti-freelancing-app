# frozen_string_literal: true

class AdminsController < ApplicationController
  def index; end

  def manage_users
    @users = User.all.order('created_at')
  end

  def manage_projects
    @projects = Project.all.order('created_at')
  end

  def manage_bids
    @bids = Bid.all.order('created_at')
  end

  def manage_categories
    @categories = Category.all.order('created_at')
  end
end

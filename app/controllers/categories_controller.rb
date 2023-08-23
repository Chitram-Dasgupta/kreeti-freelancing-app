# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :require_admin, except: []
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.all.page params[:page]
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)
    create_instance(@category, categories_path, 'Category was successfully created!',
                    'Please enter the information correctly', :new)
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, flash: { notice: 'Category was successfully updated!' }
    else
      flash.now[:error] = 'Please enter the information correctly'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, flash: { notice: 'Category was successfully deleted!' }
  end

  private

  def set_category
    @category = Category.find_by(id: params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end

# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order(created_at: :asc)
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find_by(id: params[:id])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, flash: { notice: 'Category was successfully created!' }
    else
      flash.now[:error] = 'Please enter the information correctly'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category = Category.find_by(id: params[:id])

    if @category.update(category_params)
      redirect_to categories_path, flash: { notice: 'Category was successfully updated!' }
    else
      flash.now[:error] = 'Please enter the information correctly'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find_by(id: params[:id])
    @category.destroy
    redirect_to categories_path, flash: { notice: 'Category was successfully deleted!' }
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end

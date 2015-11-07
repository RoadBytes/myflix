class CategoriesController < ApplicationController
  def show
    @category = Category.where(id: params[:id]).first
  end
end

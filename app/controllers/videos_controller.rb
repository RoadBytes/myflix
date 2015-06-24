class VideosController < ApplicationController
  before_action :require_user, except: [:front]

  def index
    @categories = Category.all
  end

  def show
    @video  = Video.find_by id: params[:id]
    @review = Review.new
  end

  def search
    @search_result = Video.search_by_title params[:search]
  end

  def front
    redirect_to home_path if current_user
  end
end

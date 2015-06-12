class VideosController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find_by id: params[:id]
  end

  def search
    @search_result = Video.search_by_title params[:search]
  end

  def front
  end
end

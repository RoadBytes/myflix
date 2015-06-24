class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @review = Review.new(review_params)

    if @review.save
      flash[:success] = "Your review has been created"
      redirect_to video_path(@review.video)
    else
      flash[:error] = "Sorry please check errors and try again"
      render 'videos/show'
    end
  end

  private
  
  def review_params
    params.require(:review).permit(:message, :rating, :user_id, :video_id)
  end
end

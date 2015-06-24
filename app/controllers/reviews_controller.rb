class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video  = Video.find_by(id: params[:video_id])
    @review = Review.new(review_params)
    @review.video = @video
    @review.user  = current_user

    if @review.save
      flash[:success] = "Your review has been created"
      redirect_to @video
    else
      flash[:danger] = "Sorry please check errors and try again"
      render 'videos/show'
    end
  end

  private
  
  def review_params
    params.require(:review).permit(:message, :rating, :user_id, :video_id)
  end
end

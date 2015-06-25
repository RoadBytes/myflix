class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video  = Video.find_by(id: params[:video_id])
    @review = @video.reviews.build(review_params.merge!(user: current_user))

    if @review.save
      flash[:success] = "Your review has been created"
      redirect_to @video
    else
      flash.now[:danger] = "Sorry please check errors and try again"
      render 'videos/show'
    end
  end

  private
  
  def review_params
    params.require(:review).permit(:message, :rating)
  end
end

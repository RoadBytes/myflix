class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video

  def user_rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating unless review.nil?
  end

  def position_assignment
    current_user.queue_items.size + 1
  end
end

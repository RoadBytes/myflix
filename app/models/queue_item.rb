class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video

  def user_rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating unless review.nil?
  end
end

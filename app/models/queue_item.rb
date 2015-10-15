class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video

  def rating
    review.rating unless review.nil?
  end

  def rating=(new_rating)
    unless review.nil?
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user_id: user.id, video_id: video.id, rating: new_rating)
      review.save(validate: false)
    end
  end

  def self.update_queue_items(queue_items, authenticated_user)
    ActiveRecord::Base.transaction do
      queue_items.each do |queue_item_data| 
        queue_item = QueueItem.find_by id: queue_item_data["id"]
        queue_item.update_attributes!(position: queue_item_data["position"], rating: queue_item_data["rating"]) if queue_item.user == authenticated_user
      end
    end
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end

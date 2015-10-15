class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video

  def user_rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating unless review.nil?
  end

  def self.update_queue_items(queue_items, authenticated_user)
    ActiveRecord::Base.transaction do
      queue_items.each do |queue_item_data| 
        queue_item = QueueItem.find_by id: queue_item_data["id"]
        queue_item.update_attributes!(position: queue_item_data["position"]) if queue_item.user == authenticated_user
      end
    end
  end
end

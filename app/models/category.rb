class Category < ActiveRecord::Base
  has_many :videos, -> { order(:title) }
  validates :name, presence: :true

  def recent_videos
    self.videos.sort_by{|video| video.created_at }.reverse[0, 6]
  end
end

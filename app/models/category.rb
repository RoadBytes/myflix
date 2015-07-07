class Category < ActiveRecord::Base
  has_many :videos, -> { order(created_at: :desc) }
  validates :name, presence: :true

  def recent_videos
    videos[0, 6]
  end
end

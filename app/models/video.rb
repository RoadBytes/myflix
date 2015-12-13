class Video < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true

  belongs_to :category
  has_many   :reviews, -> { order "created_at DESC" }

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(title)
    return [] if title.blank?
    Video.where('title ILIKE ?', '%' + title + '%')
  end

  def average_rating
    return 0 if reviews.empty?
    reviews.average(:rating)
  end

  def review_count
    reviews.size
  end
end

class Video < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true

  belongs_to :category
  has_many   :reviews, -> { order(created_at: :desc) }

  def self.search_by_title(title)
    return [] if title.blank?
    Video.where('title ILIKE ?', '%' + title + '%')
  end

  def average_rating
    return 0 if(review_count < 1)
    review_total/review_count
  end

  def review_total
    total = 0
    self.reviews.each { |review| total += review.rating }
    total
  end

  def review_count
    self.reviews.size
  end
end

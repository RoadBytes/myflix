class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true


  def self.search_by_title(title)
    Video.where('title ILIKE ?', '%' + title + '%')
  end
end

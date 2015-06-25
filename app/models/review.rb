class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates  :message, presence: true
  validates  :rating,  presence: true,
                       inclusion: (0..5).to_a
end

FactoryGirl.define do 
  factory :video do
    association     :category
    title           "Video Name"
    description     "Test video title that's not too exciting"
    large_image_url "/large.jpg"
    small_image_url "/small.jpg"
    rating          4.5
    category_id     1
    created_at      Time.now
    updated_at      Time.now
  end 
end

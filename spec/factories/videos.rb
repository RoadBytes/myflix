# require 'faker'
# 
# FactoryGirl.define do 
#   factory :video do
#     association     :category
#     title           { Faker::Lorem.words(2).join(" ") }
#     description     { Faker::Lorem.words(5).join(" ") }
#     large_image_url "/large.jpg"
#     small_image_url "/small.jpg"
#     rating          4.5
#     category_id     1
#     created_at      Time.now
#     updated_at      Time.now
#   end 
# end

require 'faker'

FactoryGirl.define do 
  factory :review do
    rating     { Random::rand(5) }
    message    { Faker::Lorem.sentences(2).join(" ") }
    user_id    1
    video_id   1

    created_at Time.now
    updated_at Time.now
  end 
end

FactoryGirl.define do 
  factory :user do
    full_name "Joe Butts"
    email     "test@test.com"
    password  "123456"

    created_at      Time.now
    updated_at      Time.now
  end 
end

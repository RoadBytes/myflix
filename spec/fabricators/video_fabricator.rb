require 'faker'

Fabricator(:video) do
  category
  title           { Faker::Lorem.words(2).join(" ") }
  description     { Faker::Lorem.words(5).join(" ") }
  large_cover     "/large.jpg"
  small_cover     "/small.jpg"
  rating          4.5
  created_at      Time.now
  updated_at      Time.now
end

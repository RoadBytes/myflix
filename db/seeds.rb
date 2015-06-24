# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'

comedies = Category.create!(name: "TV Commedies")
drama    = Category.create!(name: "TV Drama")
action   = Category.create!(name: "Action")

monk = Video.create!(title:    "Monk",
              description:     Faker::Lorem.paragraph(2),
              large_image_url: "/tmp/monk_large.jpg",
              small_image_url: "/tmp/monk.jpg",
              category:        comedies,
              rating:          4.5)

Video.create!(title:           "Video Name", 
              description:     "Test video title that's not too exciting",
              large_image_url: "/tmp/monk_large.jpg",
              small_image_url: "/tmp/futurama.jpg",
              category:        comedies,
              rating:          2.5)

Video.create!(title:           "Name two", 
              description:     "Test video title that's not too exciting also",
              large_image_url: "/tmp/monk_large.jpg",
              small_image_url: "/tmp/south_park.jpg",
              category:        comedies,
              rating:          1.0)

Video.create!(title:           "Title Two", 
              description:     "Test video title that's not too exciting again",
              large_image_url: "/tmp/monk_large.jpg",
              small_image_url: "/tmp/monk.jpg",
              category:        drama,
              rating:          2.2)

8.times do
  Video.create!(title:           Faker::Name.name,
                description:     Faker::Lorem.paragraph(2),
                large_image_url: "/tmp/monk_large.jpg",
                small_image_url: "/tmp/monk.jpg",
                category:        action,
                rating:          4.2)
end

joe = User.create!(email:     "test@test.com", 
                   full_name: "Joe Butts", 
                   password:  "123456")

4.times do
  Review.create!(message: Faker::Lorem.paragraph(2),
                 rating:  rand(5),
                 user:    joe, 
                 video:   monk)
end

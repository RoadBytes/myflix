# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


comedies = Category.create!(name: "TV Commedies")
Video.create!(name: "Monk", # videos do not have names, but titles. :)
              description: "USA's great series on the dude that is afraid of getting dirty, but needs to because he is a brilliant detective.  Hahahahahahahhahhahhahaha.",
              large_image_url: "/tmp/monk_large.jpg",
              small_image_url: "/tmp/monk.jpg",
              category: comedies,
              rating: 4.5)

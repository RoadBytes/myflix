source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt-ruby', '~> 3.1.2'

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem "factory_girl_rails", "~> 4.2.1"
  gem 'fabrication'
  gem 'letter_opener'
end

group :test, :production do
  gem "faker", "~> 1.1.2"
end

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem "shoulda-matchers"
  gem "capybara", "~> 2.1.0"
  gem "database_cleaner", "~> 1.0.1"
  gem "launchy", "~> 2.3.0"
  gem "selenium-webdriver", "~> 2.39.0"
  gem 'capybara-email'
end

group :production do
  gem 'rails_12factor'
end


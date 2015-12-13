Fabricator(:user) do
  full_name  { Faker::Name.name }
  email      { Faker::Internet.email }
  password   "123456"
  created_at Time.now
  updated_at Time.now
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end

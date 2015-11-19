Fabricator(:invitation) do
  recipient_name  { Faker::Name.name }
  recipient_email { Faker::Internet.email } 
  token           "12345"
  message         "Join US!!!"     
  created_at      Time.now
  updated_at      Time.now
end

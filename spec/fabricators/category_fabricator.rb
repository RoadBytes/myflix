require 'faker'

Fabricator(:category) do
  name           "TV Comedies"
  created_at      Time.now
  updated_at      Time.now
end

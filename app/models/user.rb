class User < ActiveRecord::Base

  validates :full_name, presence:   true
  validates :email,     presence:   true,
                        uniqueness: true
  validates :password,  presence:   true,
                        length:     { minimum: 6 },
                        if:         lambda{ new_record? || !password.nil? }
  has_many  :reviews
  has_secure_password 

end

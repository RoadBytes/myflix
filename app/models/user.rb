class User < ActiveRecord::Base

  validates :full_name, presence:   true
  validates :email,     presence:   true,
                        uniqueness: true
  validates :password,  presence:   true,
                        length:     { minimum: 6 },
                        if:         lambda{ new_record? || !password.nil? }
  has_many  :reviews
  has_many  :queue_items, -> { order(:position) }

  has_secure_password 


  def my_queue_contains?(video)
    queue_items.map{|queue_item| queue_item.video }.include?(video)
  end

  def position_assignment
    queue_items.size + 1
  end
end

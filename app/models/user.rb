class User < ActiveRecord::Base

  validates :full_name, presence:   true
  validates :email,     presence:   true,
                        uniqueness: true
  validates :password,  presence:   true,
                        length:     { minimum: 6 },
                        if:         lambda{ new_record? || !password.nil? }
  has_many  :reviews,     -> { order("created_at DESC") }
  has_many  :queue_items, -> { order(:position) }

  has_many :leader_relationships,   class_name: "Relationship", foreign_key: :follower_id
  has_many :follower_relationships, class_name: "Relationship", foreign_key: :leader_id

  has_secure_password 

  def queued_video?(video)
    queue_items.map{|queue_item| queue_item.video }.include?(video)
  end

  def position_assignment
    queue_items.size + 1
  end

  def normalize_queue_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes( position: index + 1 )
    end
  end

  def is_following?(user)
    leader_relationships.any? {|relationship| user == relationship.leader }
  end

  def can_follow?(user)
    !(self == user || self.is_following?(user))
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def clear_token
    self.token = nil
  end
end

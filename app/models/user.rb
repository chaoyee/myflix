class User < ActiveRecord::Base
  include Tokenable

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email
  has_many :reviews, -> { order(created_at: :desc)}
  has_many :queue_items, -> { order(position: :asc) } 
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id    
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  has_many :payments

  has_secure_password validations: false

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)  
    end  
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end
end
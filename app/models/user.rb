class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }
  validates_acceptance_of :agreement, allow_nil: false, on: :create
  has_secure_password
  has_many :tweets
  has_many :following_relationships, class_name: "Relationship",
                                      foreign_key: "follower_id",
                                      dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed

    # 他のユーザをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

    # フォローしているユーザをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end

  # 自分とフォローしているユーザのつぶやきを取得する
  def feed_items
    Tweet.where(user_id: following_user_ids + [self.id])
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Friendships
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  # Push subscriptions
  has_many :push_subscriptions, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }

  # Get all friends (both directions)
  def all_friends
    (friends + inverse_friends).uniq
  end

  # Check if user is friends with another user
  def friends_with?(user)
    friendships.accepted.exists?(friend: user) || inverse_friendships.accepted.exists?(user: user)
  end

  # Get pending friend requests
  def pending_friend_requests
    inverse_friendships.pending.includes(:user)
  end

  # Get sent friend requests
  def sent_friend_requests
    friendships.pending.includes(:friend)
  end
end

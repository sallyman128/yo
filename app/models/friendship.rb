class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  # Validations
  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :friend_id, uniqueness: { scope: :user_id, message: "Friendship already exists" }
  validate :not_self_referential

  # Scopes
  scope :accepted, -> { where(status: "accepted") }
  scope :pending, -> { where(status: "pending") }
  scope :rejected, -> { where(status: "rejected") }

  # Callbacks
  before_create :set_default_status

  private

  def not_self_referential
    if user_id == friend_id
      errors.add(:friend_id, "Cannot be friends with yourself")
    end
  end

  def set_default_status
    self.status ||= "pending"
  end
end

class PushSubscription < ApplicationRecord
  belongs_to :user

  # Validations
  validates :endpoint, presence: true, uniqueness: { scope: :user_id }
  validates :p256dh_key, presence: true
  validates :auth_key, presence: true

  # Scopes
  scope :active, -> { where(active: true) }

  # Callbacks
  before_create :set_default_active

  private

  def set_default_active
    self.active = true if active.nil?
  end
end

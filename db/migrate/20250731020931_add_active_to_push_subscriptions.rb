class AddActiveToPushSubscriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :push_subscriptions, :active, :boolean
  end
end

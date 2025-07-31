class CreatePushSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :push_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.text :endpoint
      t.text :p256dh_key
      t.text :auth_key

      t.timestamps
    end
  end
end

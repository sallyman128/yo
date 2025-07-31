class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:friend_id])
    message = params[:message] || "Hello from #{current_user.username}!"
    
    if friend.push_subscriptions.active.any?
      friend.push_subscriptions.active.each do |subscription|
        send_push_notification(subscription, message)
      end
      render json: { status: 'success', message: 'Notification sent' }
    else
      render json: { status: 'error', message: 'Friend has no active push subscriptions' }, status: :unprocessable_entity
    end
  end

  private

  def send_push_notification(subscription, message)
    begin
      WebPush.payload_send(
        message: {
          title: "New Message",
          body: message,
          icon: "/icon.png",
          badge: "/icon.png",
          tag: "notification-#{Time.current.to_i}",
          requireInteraction: true,
          actions: [
            {
              action: "view",
              title: "View"
            }
          ]
        }.to_json,
        endpoint: subscription.endpoint,
        p256dh_key: subscription.p256dh_key,
        auth_key: subscription.auth_key,
        vapid: {
          subject: "mailto:sender@example.com",
          public_key: Rails.application.credentials.vapid_public_key,
          private_key: Rails.application.credentials.vapid_private_key
        }
      )
    rescue => e
      Rails.logger.error "Push notification failed: #{e.message}"
    end
  end
end 
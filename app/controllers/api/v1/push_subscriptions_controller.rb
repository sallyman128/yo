class Api::V1::PushSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @subscription = current_user.push_subscriptions.build(subscription_params)
    
    if @subscription.save
      render json: { status: 'success', message: 'Subscription created' }, status: :created
    else
      render json: { status: 'error', message: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription = current_user.push_subscriptions.find(params[:id])
    
    if @subscription.destroy
      render json: { status: 'success', message: 'Subscription removed' }
    else
      render json: { status: 'error', message: 'Unable to remove subscription' }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, :p256dh_key, :auth_key)
  end
end 
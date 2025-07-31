class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @push_subscriptions = current_user.push_subscriptions.active
  end
end

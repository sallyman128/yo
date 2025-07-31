class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = current_user.all_friends
    @pending_requests = current_user.pending_friend_requests
    @sent_requests = current_user.sent_friend_requests
  end
end

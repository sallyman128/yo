class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, only: [:destroy, :accept, :reject]

  def index
    @friends = current_user.all_friends
    @pending_requests = current_user.pending_friend_requests
    @sent_requests = current_user.sent_friend_requests
    @users = User.where.not(id: current_user.id).where.not(id: current_user.all_friends.pluck(:id))
  end

  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    
    if @friendship.save
      redirect_to friendships_path, notice: 'Friend request sent!'
    else
      redirect_to friendships_path, alert: 'Unable to send friend request.'
    end
  end

  def destroy
    if @friendship.destroy
      redirect_to friendships_path, notice: 'Friendship removed.'
    else
      redirect_to friendships_path, alert: 'Unable to remove friendship.'
    end
  end

  def accept
    if @friendship.update(status: 'accepted')
      redirect_to friendships_path, notice: 'Friend request accepted!'
    else
      redirect_to friendships_path, alert: 'Unable to accept friend request.'
    end
  end

  def reject
    if @friendship.update(status: 'rejected')
      redirect_to friendships_path, notice: 'Friend request rejected.'
    else
      redirect_to friendships_path, alert: 'Unable to reject friend request.'
    end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:friend_id)
  end
end

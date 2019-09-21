class UsersController < ApplicationController
  def wave
    @user = User.find(params[:id])
    WaveChannel.broadcast_to(@user, "#{current_user.email} just waved you a hi!")
  end
end

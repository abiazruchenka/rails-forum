class LikesController < ApplicationController

  def create
    @section = Like.create!(like_params)
    @id = like_params[:message_id]
    respond_to do |f|
      f.html { redirect_to likes_url }
      f.js #?
    end
  end

  private

  def like_params
    params.fetch(:like, {}).permit!
  end
end
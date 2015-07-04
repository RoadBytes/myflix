class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    if params[:user_id].to_i == current_user.id
      QueueItem.create(user_id:  params[:user_id],
                       video_id: params[:video_id],
                       position: position_assignment)
    end

    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find_by id: params[:id]
    queue_item.delete if queue_item.user == current_user
    redirect_to my_queue_path
  end
end

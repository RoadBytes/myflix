class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    QueueItem.create(user_id: current_user.id, video_id: params[:video_id])
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find_by id: params[:id]
    queue_item.delete if queue_item.user == current_user
    redirect_to my_queue_path
  end
end

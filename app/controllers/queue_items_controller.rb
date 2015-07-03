class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def destroy
    queue_item = QueueItem.find_by id: params[:id]
    queue_item.delete
    redirect_to my_queue_path
  end
end

class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find_by id: params[:video_id]

    unless my_queue_contains?(video)
      QueueItem.create(user_id:  current_user.id,
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

  private

  def my_queue_contains?(video)
    current_user.queue_items.map{|queue_item| queue_item.video }.include?(video)
  end
end

class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find_by id: params[:video]

    unless current_user.my_queue_contains?(video)
      QueueItem.create(user:  current_user,
                       video: video,
                       position: current_user.position_assignment)
    end

    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find_by id: params[:id]
    queue_item.delete if queue_item.user == current_user
    redirect_to my_queue_path
  end
end

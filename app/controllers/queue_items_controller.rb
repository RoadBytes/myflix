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
    normalize_queue_positions
    redirect_to my_queue_path
  end

  def order
    begin
      update_queue_items
      normalize_queue_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid Position Number"
    end
    redirect_to my_queue_path
  end

  private

  def update_queue_items
    ActiveRecord::Base.transaction do
      params["queue_items"].each do |queue_item_data| 
        queue_item = QueueItem.find_by id: queue_item_data["id"]
        queue_item.update_attributes!(position: queue_item_data["position"]) if queue_item.user == current_user
      end
    end
  end

  def normalize_queue_positions
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes( position: index + 1 )
    end
  end
end

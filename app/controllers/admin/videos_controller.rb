class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(strong_video_params)
    if @video.save
      flash[:success] = "New video titled: #{@video.title} created"
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Invalid input"
      render :new
    end
  end

  private

  def strong_video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover)
  end
end

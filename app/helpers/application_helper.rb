module ApplicationHelper
  def options_for_video_reviews(value=nil)
    options_for_select((1..5).map {|num| [pluralize(num, "Star"), num]}, value.to_i)
  end
end

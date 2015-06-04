class AddVideoRating < ActiveRecord::Migration
  def change
    add_column :videos, :rating, :float
  end
end

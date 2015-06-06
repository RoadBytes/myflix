class AddVideoCategoryTables < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string  :title
      t.text    :description
      t.string  :large_image_url
      t.string  :small_image_url
      t.float   :rating
      t.integer :category_id

      t.timestamps
    end


    create_table :categories do |t|
      t.string  :name

      t.timestamps
    end

  end
end

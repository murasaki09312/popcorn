class CreateWorks < ActiveRecord::Migration[8.1]
  def change
    create_table :works do |t|
      t.string :title
      t.string :video_url
      t.string :tags
      t.text :description

      t.timestamps
    end
  end
end

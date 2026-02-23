class CreateSiteSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :site_settings do |t|
      t.integer :singleton_guard, null: false, default: 0
      t.text :about_text, null: false, default: ""
      t.string :contact_text, null: false, default: ""
      t.string :instagram_url
      t.string :youtube_url
      t.string :line_url

      t.timestamps
    end

    add_index :site_settings, :singleton_guard, unique: true
  end
end

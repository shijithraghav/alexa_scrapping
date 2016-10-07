class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :url_name
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
    add_index :websites, [:url_name, :user_id]
  end
end

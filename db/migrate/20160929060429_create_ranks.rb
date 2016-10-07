class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer :rank
      t.integer :old_rank
      t.references :website, foreign_key: true

      t.timestamps null: false
    end
    add_index :ranks, [:website_id, :created_at], unique: true
  end
end

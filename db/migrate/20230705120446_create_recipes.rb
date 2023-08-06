class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.text :body
      t.text :serving, null: false
      t.text :cooking_time
      t.integer :user_id, null: false
      t.integer :genre_id, null: false
      t.integer :price_range_id, null: false
      t.boolean :is_deleted, null: false, default: false
      t.timestamps
    end
  end
end

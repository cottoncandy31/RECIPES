class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.integer :recipe_id, null: false
      t.string :name
      t.string :quantity
      t.timestamps
    end
  end
end

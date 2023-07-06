class CreatePriceRanges < ActiveRecord::Migration[6.1]
  def change
    create_table :price_ranges do |t|
      t.integer :minimum_price, null: false
      t.integer :maximum_price, null: false
      t.timestamps
    end
  end
end

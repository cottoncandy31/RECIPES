class CreatePriceRanges < ActiveRecord::Migration[6.1]
  def change
    create_table :price_ranges do |t|
      #seedsファイルのデータ内で価格帯の数値が被らないようにするため、unique: trueを設定する
      t.integer :minimum_price, null: false, unique: true
      t.integer :maximum_price, null: false, unique: true
      t.string :name
      t.timestamps
    end
  end
end

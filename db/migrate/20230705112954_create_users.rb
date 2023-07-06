class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.boolean :is_deleted, null: false, default: false
      t.timestamps
    end
  end
end

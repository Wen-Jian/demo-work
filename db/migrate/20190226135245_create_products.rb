class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :item_name
      t.integer :item_price
      t.integer :discount
      t.string :image
      t.string :description
      t.timestamps
    end
  end
end

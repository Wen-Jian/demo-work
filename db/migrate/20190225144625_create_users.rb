class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :account, null: false, index: true, unique: true
      t.string :password, null: false
      t.references :role
      t.timestamps
    end
  end
end

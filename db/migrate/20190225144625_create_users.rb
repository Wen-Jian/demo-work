class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :account, null: false
      t.string :password, null: false
      t.reference :roles
      t.timestamps
    end

    add_index :users, :role_id
  end
end

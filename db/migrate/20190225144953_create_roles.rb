class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.integer :user_role, limit: 1, index: true, unique: true
      t.boolean :discount_flag, default: false
      t.timestamps
    end
  end
end

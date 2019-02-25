class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.integer :user_role, limit: 1
      t.boolean :edit_authority
      t.boolean :discount_flag
      t.timestamps
    end
  end
end

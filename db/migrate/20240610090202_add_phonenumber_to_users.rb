class AddPhonenumberToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :phone_number, :string
  end

  def down
    remove_column :users, :phone_number, :string
  end
end

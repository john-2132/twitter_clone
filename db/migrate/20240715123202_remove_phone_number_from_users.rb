# frozen_string_literal: true

class RemovePhoneNumberFromUsers < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :phone_number, :string
  end

  def down
    add_column :users, :phone_number, :string, default: '', null: false
  end
end

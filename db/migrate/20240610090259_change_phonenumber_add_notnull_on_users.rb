# frozen_string_literal: true

class ChangePhonenumberAddNotnullOnUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :phone_number, false
  end
end

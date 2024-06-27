# frozen_string_literal: true

class ChangeColumnDefaultToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.change_default(:name, from: nil, to: '')
      t.change_default(:birth_date, from: nil, to: '1930/1/1')
      t.change_default(:phone_number, from: nil, to: '')
    end
  end
end

# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :name, null: false, default: ''
      t.date :birth_date, null: false, default: '1930/1/1'
      t.string :phone_number, null: false, default: ''
      t.text :self_introduction, default: ''
      t.string :place, default: ''
      t.string :web_site, default: ''
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end

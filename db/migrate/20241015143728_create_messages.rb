# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :text
      t.references :user, null: false, foreign_key: true
      t.references :message_room, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
    add_check_constraint :messages, "(
      char_length(
        regexp_replace(text, '[\\u0000-\\u007F]', '', 'g')
      ) * 2 +
      char_length(
        regexp_replace(text, '[^\\u0000-\\u007F]', '', 'g')
      )
    ) <= 10000", name: 'text_length_check'
  end
end

# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :chat_session, null: false, foreign_key: true
      t.references :messageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end

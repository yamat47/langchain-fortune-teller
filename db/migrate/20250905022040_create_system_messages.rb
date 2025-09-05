# frozen_string_literal: true

class CreateSystemMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :system_messages do |t|
      t.text :content

      t.timestamps
    end
  end
end

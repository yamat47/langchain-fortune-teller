# frozen_string_literal: true

class CreateUserMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :user_messages do |t|
      t.text :content

      t.timestamps
    end
  end
end

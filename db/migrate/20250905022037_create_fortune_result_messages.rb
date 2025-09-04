# frozen_string_literal: true

class CreateFortuneResultMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :fortune_result_messages do |t|
      t.string :service_name
      t.text :service_description
      t.text :reason
      t.string :reference_url

      t.timestamps
    end
  end
end

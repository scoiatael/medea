# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations, id: :uuid do |t|
      t.text :name, null: false
      t.st_point :lonlat, null: true
      t.boolean :inside, null: true

      t.timestamps
    end
  end
end

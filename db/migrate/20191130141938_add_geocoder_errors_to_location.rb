# frozen_string_literal: true

class AddGeocoderErrorsToLocation < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :geocoder_errors, :string, array: true, default: []
  end
end

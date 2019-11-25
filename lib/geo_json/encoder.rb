# frozen_string_literal: true

require 'rgeo/geo_json'
module GeoJSON
  class Encoder
    def call(feature)
      RGeo::GeoJSON.encode(feature)
    end
  end
end

# frozen_string_literal: true

require 'rgeo/geo_json'
module GeoJSON
  class Decoder
    class MissingGeometry < StandardError; end

    def call(json)
      RGeo::GeoJSON.decode(json).tap do |maybe_geo|
        raise MissingGeometry, 'failed to decode into known geometry' if maybe_geo.nil?
      end
    end
  end
end

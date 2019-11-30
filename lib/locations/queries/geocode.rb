# frozen_string_literal: true

require 'geokit'

module Locations
  module Queries
    class Geocode
      GEOCODER = Geokit::Geocoders::OSMGeocoder

      def call(location_name)
        GEOCODER.geocode(location_name)
      end
    end
  end
end

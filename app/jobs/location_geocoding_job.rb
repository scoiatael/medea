# frozen_string_literal: true

require 'geokit'
class LocationGeocodingJob < ApplicationJob
  queue_as :default

  GEOCODER = Geokit::Geocoders::OSMGeocoder

  def perform(location)
    return unless location.lonlat.nil?

    # TODO: Decouple from tests.
    geo_loc = GEOCODER.geocode(location.name)
    # TODO: Handle errors
    return if geo_loc.lat.nil? || geo_loc.lng.nil?

    location.lonlat = "POINT(#{geo_loc.lng} #{geo_loc.lat})"
    location.save!
  end
end

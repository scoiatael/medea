# frozen_string_literal: true

class LocationGeocodingJob < ApplicationJob
  include Dry::Effects.Resolve(
    geocode: 'locations.queries.geocode',
    contain: 'areas.queries.contain',
    repo: 'areas.repo.file'
  )

  ERROR_INVALID_LOCATION = 'invalid_location_name'

  queue_as :default

  def perform(location)
    return unless location.lonlat.nil?

    geo_loc = geocode.call(location.name)
    process(location, geo_loc)
    location.save!
  end

  private

  def process(location, geo_loc)
    return add_error(location) unless valid_geolocation?(geo_loc)

    location.lonlat = "POINT(#{geo_loc.lng} #{geo_loc.lat})"
    location.inside = contain.call(repo.all, location.lonlat)
  end

  def add_error(location)
    location.geocoder_errors << ERROR_INVALID_LOCATION
  end

  def valid_geolocation?(geo_loc)
    geo_loc.lat.present? && geo_loc.lng.present?
  end
end

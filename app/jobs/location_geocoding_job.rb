# frozen_string_literal: true

class LocationGeocodingJob < ApplicationJob
  include Dry::Effects.Resolve(
    geocode: 'locations.queries.geocode',
    contain: 'areas.queries.contain',
    repo: 'areas.repo.file'
  )

  queue_as :default

  def perform(location)
    return unless location.lonlat.nil?

    geo_loc = geocode.call(location.name)
    # TODO: Handle errors
    return if geo_loc.lat.nil? || geo_loc.lng.nil?

    location.lonlat = "POINT(#{geo_loc.lng} #{geo_loc.lat})"
    location.inside = contain.call(repo.all, location.lonlat)
    location.save!
  end
end

# frozen_string_literal: true

require 'rgeo/geo_json'

# LocationQueriesController responds to simple queries about locations
class LocationQueriesController < ApplicationController
  AREAS = 'db/areas.json'

  def show
    render json: RGeo::GeoJSON.encode(areas)
  end

  def inside?
    param = request.GET[:q]
    point = to_point(param)
    render json: areas.any? { |a| a.geometry.contains?(point) }
  end

  private

  def areas
    RGeo::GeoJSON.decode(File.read(AREAS))
  end

  def to_point(json)
    RGeo::GeoJSON.decode(json)
  end
end

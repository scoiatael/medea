require 'rgeo/geo_json'

class LocationQueriesController < ApplicationController
  AREAS = 'db/areas.json'

  def show
    areas = load_areas
    render json: RGeo::GeoJSON.encode(areas)
  end

  def inside?
    render json: true
  end

  private

  def load_areas
    RGeo::GeoJSON.decode(File.read(AREAS))
  end
end

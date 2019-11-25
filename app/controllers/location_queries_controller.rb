# frozen_string_literal: true

require 'rgeo/geo_json'

# LocationQueriesController responds to simple queries about locations
class LocationQueriesController < ApplicationController
  AREAS = 'db/areas.json'

  class MissingGeometry < StandardError; end

  def show
    render json: RGeo::GeoJSON.encode(areas)
  end

  def inside?
    param = params.required(:q)
    point = to_point!(param)
    render json: areas_contain?(point)
  rescue ActionController::ParameterMissing
    render json: { error: :missing_query_param }, status: :bad_request
  rescue JSON::ParserError, MissingGeometry
    render json: { error: :invalid_json }, status: :bad_request
  end

  private

  def areas
    RGeo::GeoJSON.decode(File.read(AREAS))
  end

  # TODO: Extract & test
  def to_point!(json)
    RGeo::GeoJSON.decode(json).tap do |maybe_point|
      raise MissingGeometry, 'failed to decode into known geometry' if maybe_point.nil?
    end
  end

  # TODO: Extract & test
  def areas_contain?(point)
    areas.any? { |a| a.geometry.contains?(point) }
  end
end

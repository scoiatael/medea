# frozen_string_literal: true

# LocationQueriesController responds to simple queries about locations
class LocationQueriesController < ApplicationController
  include Dry::Effects.Resolve(
    encoder: 'geo_json.encoder',
    decoder: 'geo_json.decoder',
    contain: 'areas.queries.contain',
    repo: 'areas.repo.file'
  )

  def show
    render json: encoder.call(repo.all)
  end

  def inside?
    point = decoder.call(params.required(:q))
    render json: contain.call(repo.all, point)
  rescue ActionController::ParameterMissing
    render json: { error: :missing_query_param }, status: :bad_request
  rescue JSON::ParserError, GeoJSON::Decoder::MissingGeometry, Areas::Queries::Contain::UnsupportedType
    render json: { error: :invalid_json }, status: :bad_request
  end
end

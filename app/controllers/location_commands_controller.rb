# frozen_string_literal: true

class LocationCommandsController < ApplicationController
  class ExistingRecordNameMismatch < StandardError; end

  def create_by_id
    id, name = params.require(%i[id name])
    status = :ok
    location = Location.find_or_create_by(id: id) do |creating|
      status = :created
      creating.name = name
    end
    raise ExistingRecordNameMismatch, "existing record with id #{id} has name #{name}" unless location.name == name

    render json: { id: id }, status: status
  rescue ExistingRecordNameMismatch => e
    render json: { error: e }, status: :conflict
  end
end

# frozen_string_literal: true

class LocationCommandsController < ApplicationController
  class IDNotUnique < StandardError; end

  include Dry::Effects.Resolve(
    create!: 'location.commands.create'
  )

  def create
    name = params.require(:name)
    created, location = create!.call(id: SecureRandom.uuid, name: name)
    # Chance for that is astronomically low, but still... It could point to attack, or issues on our side.
    raise IDNotUnique, "conflict on #{location.id}" unless created

    render json: { id: location.id }, status: :created
  end

  def create_by_id
    id, name = params.require(%i[id name])
    created, = create!.call(id: id, name: name)
    render json: { id: id }, status: created ? :created : :ok
  rescue ActiveRecord::RecordNotUnique, Location::Commands::Create::ExistingRecordNameMismatch => e
    render json: { error: e }, status: :conflict
  end
end

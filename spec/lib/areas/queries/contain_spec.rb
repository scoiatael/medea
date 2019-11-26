# frozen_string_literal: true

require 'rails_helper'
require_relative '../../../../lib/areas/queries/contain'

RSpec.describe Areas::Queries::Contain do
  # See https://gist.github.com/scoiatael/bf6f335ea22c8a4cddf35b0f1963f439 for points and areas
  subject { described_class.new.call(areas, point) }

  # This is the light-blue area around Wien
  let(:areas) do
    [RGeo::GeoJSON.decode(File.read("#{File.dirname(__FILE__)}/area.json"))]
  end

  # This is the red one in the middle
  context 'when point is outside the area' do
    let(:point) { make_point(lat: 48.2832, long: 15.2930) }

    it { is_expected.to eq(false) }
  end

  # This is the green one to south-west of Ostrava
  context 'when point is inside the area' do
    let(:point) { make_point(lat: 49.3824, long: 17.8418) }

    it { is_expected.to eq(true) }
  end

  def make_point(long:, lat:)
    RGeo::GeoJSON.decode("{\"type\":\"Point\",\"coordinates\":[#{long}, #{lat}]}")
  end
end

# frozen_string_literal: true

require 'rails_helper'
require_relative '../../../../lib/areas/queries/contain'

RSpec.describe Areas::Queries::Contain do
  subject { described_class.new.call(areas, point) }

  # See https://gist.github.com/scoiatael/bf6f335ea22c8a4cddf35b0f1963f439 for points and areas
  context 'when given geospatial data' do
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
  end

  context 'when given tricky data' do
    let(:areas) do
      [make_polygon([0.0, 0.0], [-2.0, 1.0], [5.0, 3.0], [-1.5, -2.0], [0.0, 0.0])]
    end

    context 'when point is outside the area' do
      [-1.75, -1.25].each do |x|
        [-0.1, 0.1].each do |y|
          let(:point) { make_point(lat: y, long: x) }

          it { is_expected.to eq(false) }
        end
      end
    end

    context 'when point is inside the area' do
      [
        [-1.75, 0.9],
        [1.0, 1.0]
      ].each do |(x, y)|
        let(:point) { make_point(lat: y, long: x) }

        it { is_expected.to eq(true) }
      end
    end
  end

  def make_point(long:, lat:)
    RGeo::GeoJSON.decode("{\"type\":\"Point\",\"coordinates\":[#{long}, #{lat}]}")
  end

  def make_polygon(*coords)
    json = JSON.dump(coords)
    RGeo::GeoJSON.decode("{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[#{json}]}}")
  end
end

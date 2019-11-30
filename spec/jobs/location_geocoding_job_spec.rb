# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationGeocodingJob, type: :job do
  include Dry::Effects::Handler.Resolve

  around do |spec|
    DependencyResolver.testing do
      spec.run
    end
  end

  let(:geocode) { double(:geocode) }
  let(:geocoder_point) { double(:geocoder_point, lat: 30.2711286, lng: -97.7436995) }

  around do |spec|
    provide('locations.queries.geocode' => geocode) { spec.run }
  end

  let(:name) { 'Austin' }
  let(:location) { Location.create!(name: name) }

  describe 'perform!' do
    before do
      expect(geocode).to receive(:call).with(name).and_return(geocoder_point)
      described_class.new.perform(location)
    end

    it 'adds .latlon to location' do
      expect(location.lonlat).not_to be_nil
      expect(location.lonlat.x).to eq(geocoder_point.lng)
      expect(location.lonlat.y).to eq(geocoder_point.lat)
    end
  end
end

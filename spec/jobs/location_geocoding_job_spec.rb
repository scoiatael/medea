# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationGeocodingJob, type: :job do
  include Dry::Effects::Handler.Resolve

  around do |spec|
    DependencyResolver.testing { spec.run }
  end

  let(:geocode) { double(:geocode) }

  around do |spec|
    provide('locations.queries.geocode' => geocode) { spec.run }
  end

  let(:name) { 'Austin' }
  let(:geocoder_point) { double(:geocoder_point, lat: 30.2711286, lng: -97.7436995) }
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

    it 'adds .inside to location' do
      expect(location.inside).not_to be_nil
    end

    context 'when given point outside any areas' do
      it 'sets .inside to false' do
        expect(location.inside).to be_falsey
      end
    end

    context 'when given point in some area' do
      let(:name) { 'Nashville' }
      let(:geocoder_point) { double(:geocoder_point, lat: 36.20, lng: -86.78) }

      it 'sets .inside to true' do
        expect(location.inside).to be_truthy
      end
    end

    context 'when geocoder fails to return a valid geolocation' do
      let(:geocoder_point) { double(:geocoder_point, lat: nil, lng: nil) }

      it 'add error to location#geocoder_errors' do
        expect(location.geocoder_errors).to eq(['invalid_location_name'])
      end
    end
  end
end

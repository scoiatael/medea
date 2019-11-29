# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationGeocodingJob, type: :job do
  let(:name) { 'Austin' }
  let(:location) do
    Location.create!(name: name)
  end

  describe 'perform!' do
    before do
      described_class.new.perform(location)
    end

    it 'adds .latlon to location' do
      expect(location.lonlat).not_to be_nil
    end
  end
end

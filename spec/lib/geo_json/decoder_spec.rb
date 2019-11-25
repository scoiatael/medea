# frozen_string_literal: true

require 'rails_helper'
require_relative '../../../lib/geo_json/decoder.rb'

RSpec.describe GeoJSON::Decoder do
  subject { described_class.new.call(json) }

  context 'when given invalid JSON' do
    let(:json) { '{' }
    it 'raises JSON::ParserError' do
      expect { subject }.to raise_error JSON::ParserError
    end
  end

  context "when given JSON that doesn't match any geometry" do
    let(:json) { '{}' }

    it 'raises GeoJSON::Decoder::MissingGeometry' do
      expect { subject }.to raise_error GeoJSON::Decoder::MissingGeometry
    end
  end

  context 'when given proper GeoJSON' do
    let(:json) { '{"type":"Point","coordinates":[8.3,50.66]}' }

    it 'raises no errors' do
      expect { subject }.not_to raise_error
    end

    it 'returns feature that has geometry' do
      expect(subject).to respond_to :geometry_type
      expect(subject).to respond_to :contains?
    end
  end
end

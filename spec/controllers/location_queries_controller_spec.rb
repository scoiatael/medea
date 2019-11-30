# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationQueriesController, type: :controller do
  around do |spec|
    DependencyResolver.testing do
      spec.run
    end
  end

  describe 'GET /location' do
    it 'returns a list of locations' do
      get :show

      expect(response).to have_http_status(:ok)
      body = response.body
      expect(body).not_to be_empty
      parsed = JSON.parse(body)
      expect(parsed).to have_key('features')
      expect(parsed['features'].size).to eq(6)
    end
  end

  describe 'GET /location/inside' do
    context 'with JSON-encoded query' do
      it 'checks if point is inside any area' do
        get :inside?, params: { q: '{"type":"Point","coordinates":[8.3,50.66]}' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('true')
      end
    end

    context 'with invalid parameters' do
      params_to_error = {
        { q: '' } => :missing_query_param,
        {} => :missing_query_param,
        { q: '}' } => :invalid_json,
        { q: '{"type":"Point","coordinates":[8.3]}' } => :invalid_json,
        { q: '{"type":"Polygon","coordinates":[[[12.32,48.10],[12.06,48.06],[12.54,46.66],[12.32,48.10]]]}' } => :invalid_json
      }

      params_to_error.each do |params, error|
        it "returns bad request and error=#{error} for #{params}" do
          get :inside?, params: params

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to eq(JSON.dump(error: error))
        end
      end
    end
  end

  describe 'GET /location/by-id' do
    before do
      get :by_id, params: { id: id }
    end

    context 'when ID is not found' do
      let(:id) { SecureRandom.uuid }

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when ID belongs to a Location' do
      let(:name) { 'Austin' }
      let(:id) { Location.create!(name: name).id }
      let(:parsed) do
        body = response.body
        expect(body).not_to be_empty
        JSON.parse(response.body)
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns name' do
        expect(parsed['name']).to eq(name)
      end

      it 'returns only whitelisted params' do
        expected_keys = %w[name inside lonlat]
        parsed_keys = parsed.keys
        expect(parsed_keys - expected_keys).to be_empty
        expect(expected_keys - parsed_keys).to be_empty
      end
    end
  end
end

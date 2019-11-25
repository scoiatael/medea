# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationQueriesController, type: :controller do
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
        { q: '{"type":"Point","coordinates":[8.3]}' } => :invalid_json
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
end

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
    it 'checks if point is inside any area' do
      get :inside?, params: { q: '{"type":"Point","coordinates":[8.3,50.66]}' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('true')
    end
  end
end

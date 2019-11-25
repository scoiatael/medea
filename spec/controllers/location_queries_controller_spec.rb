require 'rails_helper'

RSpec.describe LocationQueriesController, type: :controller do
  describe 'GET /location' do
    it 'returns a list of locations' do
      get :show

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /location/inside' do
    it 'checks if point is inside any area' do
      get :inside?

      expect(response).to have_http_status(:ok)
    end
  end
end

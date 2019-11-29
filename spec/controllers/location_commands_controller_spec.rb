# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationCommandsController, type: :controller do
  around do |spec|
    DependencyResolverMiddleware.new(nil).testing do
      spec.run
    end
  end

  describe 'PUT /location_commands/create/:id' do
    # TODO: Use Factory for params
    let(:id) { SecureRandom.uuid }
    let(:name) { 'Austin' }

    context 'with non-UUID id' do
      [1, 'fo', '1', SecureRandom.uuid[1..-4]].each do |id|
        fit "returns 400 for id=#{id}" do
          put :create_by_id, params: { id: id, name: name }

          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'with fresh id' do
      before do
        put :create_by_id, params: { id: id, name: name }
      end

      it 'returns 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns id' do
        expect(response.body).to eq(JSON.dump(id: id))
      end

      it 'creates new location' do
        expect(Location.where(id: id).count).to eq(1)
      end
    end

    context 'with stale id' do
      before do
        Location.create!(id: id, name: name)

        put :create_by_id, params: { id: id, name: new_name }
      end

      context 'when old name is different from new name' do
        let(:new_name) { 'New York' }

        it 'returns 409' do
          expect(response).to have_http_status(:conflict)
        end

        it "doesn't create new location" do
          expect(Location.where(id: id).count).to eq(1)
        end
      end

      context 'when old name is equal to new name' do
        let(:new_name) { name }

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns id' do
          expect(response.body).to eq(JSON.dump(id: id))
        end

        it "doesn't create new location" do
          expect(Location.where(id: id).count).to eq(1)
        end
      end
    end
  end

  describe 'POST /location_commands/create' do
    let(:name) { 'Austin' }
    before do
      post :create, params: { name: name }
    end

    it 'returns 201' do
      expect(response).to have_http_status(:created)
    end

    it 'returns id' do
      body = response.body
      expect(body).not_to be_empty
      parsed = JSON.parse(response.body)
      expect(parsed).to have_key('id')
      expect(parsed['id']).not_to be_empty
    end

    it 'creates new location' do
      expect(Location.where(name: name).count).to eq(1)
    end
  end
end

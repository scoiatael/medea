# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationCommandsController, type: :controller do
  describe 'PUT /location_commands/create/:id' do
    # TODO: Use Factory for params
    let(:id) { SecureRandom.uuid }
    let(:name) { 'Austin' }

    context 'with fresh id' do
      before do
        put :create_by_id, params: { id: id, name: name }
      end

      it 'returns 204' do
        expect(response).to have_http_status(:created)
      end

      it 'creates id' do
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
end

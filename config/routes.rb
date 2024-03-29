# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :location_commands, only: [] do
    put '/create/:id', to: 'location_commands#create_by_id'
    post '/create', to: 'location_commands#create'
  end

  resource :location_queries, only: [:show] do
    get 'inside', to: 'location_queries#inside?'
    get 'by_id/:id', to: 'location_queries#by_id'
  end
end

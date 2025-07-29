# frozen_string_literal: true

Rails.application.routes.draw do
  # Root path (for HTML fallback or base landing page)
  root 'home#index'

resources :users, only: [ :index, :show, :destroy ] do
  member do
    get :events
  end
end

get '/profile', to: 'users#profile'
get '/events', to: 'events#index'
  namespace :admin do
    get '/dashboard', to: 'dashboard#index'
    get '/events', to: 'events#index'
  end

  devise_for :users,
    path: '',
    path_names: {
      sign_in:      'login',
      sign_out:     'logout',
      registration: 'signup',
    },
    controllers: {
      sessions:      'users/sessions',
      registrations: 'users/registrations',
    }

  # API routes, versioned as v1, using controllers in app/controllers/api/v1/
  namespace :v1, module: 'api/v1', path: '/v1' do
    devise_for :users,
      path: '',
      path_names: {
        sign_in:      'login',
        sign_out:     'logout',
        registration: 'signup',
      },
      controllers: {
        sessions:      'api/v1/sessions',
        registrations: 'api/v1/registrations',
      }

    get    '/profile',       to: 'users#profile'
    post   '/subscribe',     to: 'subscriptions#create'
    delete '/unsubscribe',   to: 'unsubs#destroy'
    post   '/event',         to: 'events#create'
    
    namespace :admin do
      get '/analytics/dashboard', to: 'analytics#dashboard'
      get '/analytics/events',    to: 'analytics#events'
    end
  end
end

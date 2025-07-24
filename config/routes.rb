Rails.application.routes.draw do
  # Root path (for HTML fallback or base landing page)
  root 'home#index'

  # Admin routes (HTML only)
  # devise_for :admins, path: 'admin', controllers: {
  #   sessions: 'admin/sessions'
  # }

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
  end
end

Snapwall::Application.routes.draw do
  resources :snap, only: [:index]

  root 'snap#index'
end

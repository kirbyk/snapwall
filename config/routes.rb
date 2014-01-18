Snapwall::Application.routes.draw do
  resources :snap, only: [:index] do
    member do
      get 'like'
    end
  end

  root 'snap#index'
end

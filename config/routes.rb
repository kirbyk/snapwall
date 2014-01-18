Snapwall::Application.routes.draw do
  resources :snap, only: [:index] do
    member do
      get 'like'
      get 'flag'
    end
  end

  root 'snap#index'
end

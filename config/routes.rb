Snapwall::Application.routes.draw do
  resources :snap, only: [:index, :create] do
    member do
      get 'like'
      get 'flag'
    end
  end

  root 'snap#index'
end

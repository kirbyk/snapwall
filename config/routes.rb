Snapwall::Application.routes.draw do
  resources :snap, only: [:index]
end

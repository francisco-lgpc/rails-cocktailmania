Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Attachinary::Engine => "/attachinary"
  root to: 'cocktails#index'
  get '/cocktails/search', to: 'cocktails#search'
  resources :cocktails, except: [:destroy]  do
    resources :doses, only: [:create, :new, :destroy]
  end
end

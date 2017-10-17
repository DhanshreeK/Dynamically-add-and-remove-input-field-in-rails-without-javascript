Rails.application.routes.draw do
  resources :ingredients
  resources :receipes do
  	member do
  		get :add_ingredient
  	end
  end
  resources :products do
  	resources :items
  end
  root 'receipes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

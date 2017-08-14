Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
  	get '/users/sign_out' => 'devise/sessions#destroy' 
	end


  resources :users do
  	resource :profile
  end
  
  resources :profiles do
  	resource :leave_requests
  	resource :leave_reviews
  end 
	get 'about' => 'pages#about'
	root 'pages#home'
end

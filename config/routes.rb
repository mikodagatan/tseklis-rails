Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
  	get '/users/sign_out' => 'devise/sessions#destroy' 
	end


  resources :users do
  	resource :profile
  	resources :employments
  end

  resources :leave_requests 
  
  resources :companies
  
	get 'about' => 'pages#about'
	root 'pages#home'
end

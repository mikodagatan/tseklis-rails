Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
  	get '/users/sign_out' => 'devise/sessions#destroy'
	end

  resources :users do
  	resource :profile
  	resources :employments do
      resources :leave_requests
    end
  end

  resources :companies do
    resources :leave_types
    resources :holidays
  end


  namespace :dashboard do
    resources :contact_messages
    resources :endorsements
    resources :features
    resources :owners
    resources :plans
    resources :roles
    resources :testimonials
    resources :site_settings
    resources :landing_page_settings
    resources :user_home_page_settings
    resources :plans
    root to: "site_settings#index"
  end

	get 'about' => 'pages#about'
	root 'pages#home'
end

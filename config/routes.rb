Rails.application.routes.draw do
  get 'notifications/link_through'

  devise_for :admins
  devise_for :users, controllers: { registrations: 'users/registrations', confirmations: 'confirmations' }

  devise_scope :user do
  	get '/users/sign_out' => 'devise/sessions#destroy'
	end

  resources :users do

  	resource :profile
  	resources :employments do
      resources :leave_requests do
        resource :rejection_message
      end
      get 'leave_request_by_hr' => 'leave_requests#leave_request_by_hr'
    end
  end

  resources :companies do
    resources :leave_types
    resources :holidays
    get 'employees' => 'companies#employees_index'
    get 'leave_requests' => 'companies#leave_requests_index'
    resources :invites
  end

  get 'notifications/:id/link_through', to: 'notifications#link_through', as: :link_through
  get 'notifications/notification_index' => 'notifications#notification_index'



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
    devise_for :admins, skip: :registrations
  end

  get 'search' => 'pages#search'
  get 'team' => 'pages#team'
	get 'about' => 'pages#about'
	root 'pages#home'
end

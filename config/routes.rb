Rails.application.routes.draw do
  devise_for :users
	get 'about' => 'pages#about'
	root 'pages#home'
end

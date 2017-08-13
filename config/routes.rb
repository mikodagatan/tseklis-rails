Rails.application.routes.draw do
	get 'about' => 'pages#about'
	root 'pages#home'
end

Headcountapp::Application.routes.draw do
	namespace :admin do
    get '', to: 'dashboard#index', as: '/'
  end
  
  mount API => '/'

  devise_for :users, controllers: {sessions: "sessions"}
  root :to => 'home#index'
end

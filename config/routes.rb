Rails.application.routes.draw do

	resources :investments 

  get 'home/index'

  root 'investments#new'
end

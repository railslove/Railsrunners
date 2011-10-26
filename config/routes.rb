Railscampxk::Application.routes.draw do
  devise_for :users

  match 'participate', :to => "participation#new", :via => :get
  match 'participate', :to => "participation#create", :via => :post

  match 'runs', :to => "runs#new", :via => :get, :as => 'new_run'
  resources :runs, :only => [:create]
  root :to => "runs#index"
end

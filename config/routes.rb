Railscampxk::Application.routes.draw do
  devise_for :users

  match 'participate', :to => "participation#new", :via => :get
  match 'participate', :to => "participation#create", :via => :post

  resources :runs do
    collection do
    get :what
    get :results
    get :license
    get :contact
    end
    member do
      get :insert_result
      #post
    end
  end
  root :to => "runs#what"
end

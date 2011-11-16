Railscampxk::Application.routes.draw do
  devise_for :users

  resources :participants

  resources :runs do
    collection do
    get :what
    get :results
    get :license
    get :contact
    end
  end
  root :to => "runs#what"
end

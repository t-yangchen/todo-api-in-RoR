Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      #task routes
      get "/tasks", to: "tasks#index"
      post "/tasks", to: "tasks#create"
      get "/tasks/:id", to: "tasks#show"
      patch "/tasks/:id", to: "tasks#update"
      delete "/tasks/:id", to: "tasks#destroy"
      get "/complete", to: "tasks#complete"
      get "/incomplete", to: "tasks#incomplete"

      #user routes
      get "/users", to: "users#index"
      post "/users", to: "users#sign_up"
      post "/users/login", to: "users#login"
      patch "/users/:id", to: "users#update"
      delete "/users/:id", to: "users#destroy"
      delete "/logout", to: "users#sign_out"

      #password routes
      post '/password/forgot', to: 'passwords#forgot'
      post '/password/reset', to: 'passwords#reset'
      patch '/password/update', to: 'passwords#update'
      
    end
  end
end

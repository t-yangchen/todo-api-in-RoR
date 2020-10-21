Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      #task routes
      
      post "/users/:user_id/tasks", to: "tasks#create"
      get "/users/:user_id/tasks", to: "tasks#show"
      patch "/users/:user_id/tasks/:id", to: "tasks#update"
      delete "/users/:user_id/tasks/:id", to: "tasks#destroy"
      get "/users/:user_id/tasks/complete", to: "tasks#complete"
      get "/users/:user_id/tasks/incomplete", to: "tasks#incomplete"

      #user routes
      get "/users", to: "users#index"
      post "/users/sign_up", to: "users#sign_up"
      post "/users/login", to: "users#login"
      patch "/users/update", to: "users#update"
      delete "/users/:id", to: "users#destroy"

      #password routes
      post '/password/forgot', to: 'passwords#forgot'
      post '/password/reset', to: 'passwords#reset'
      patch '/password/update', to: 'passwords#update'      
    end
  end
end

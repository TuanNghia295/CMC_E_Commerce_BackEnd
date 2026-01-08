# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      post "auth/logout", to: "auth#logout"
      post "auth/refresh", to: "auth#refresh"

      namespace :admin do
        post "auth/login", to: "auth#login"
        post "auth/logout", to: "auth#logout"
      end
    end
  end
end

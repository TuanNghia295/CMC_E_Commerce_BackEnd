# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      post "auth/logout", to: "auth#logout"
      post "auth/refresh", to: "tokens#refresh"
  end
end
end

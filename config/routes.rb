Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # auth: Chỉ định AuthController (file app/controllers/auth_controller.rb
  # login: Chỉ định hàm def login bên trong controller đó sẽ là nơi tiếp nhận dữ liệu.
  post "/auth/register", to: "auth#register"
  post "/auth/login", to: "auth#login"

  post "/token/refresh", to: "tokens#refresh"
  post "/token/logout", to: "tokens#logout"
end

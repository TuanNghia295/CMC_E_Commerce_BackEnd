Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173", "http://127.0.0.1:5173", "https://cmc-dashboard.netlify.app", "https://ebe957b0e16a.ngrok-free.app"

    resource "/api/v1/*",
      headers: :any,
      methods: %i[get post put patch delete options],
      credentials: true
  end
end

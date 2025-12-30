FactoryBot.define do
  factory :user do
    email { "user_#{SecureRandom.hex(4)}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    full_name { 'Test User' }
  end
end

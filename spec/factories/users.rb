FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    full_name { Faker::Name.name }
    role { "user" }
    deleted_at { nil }

    trait :admin do
      role { "admin" }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end

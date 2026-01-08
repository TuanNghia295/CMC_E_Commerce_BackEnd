# db/seeds.rb

# Tạo tài khoản admin
admin = User.find_or_create_by!(email: "admin@gmail.com") do |user|
  user.full_name = "Admin User"
  user.password = "123123"
  user.password_confirmation = "123123"
  user.role = "admin"
end

puts "Admin account created: #{admin.email}"

# Tạo 3 tài khoản user
3.times do |i|
  user = User.find_or_create_by!(email: "tuanghia#{i+1}@gmail.com") do |u|
    u.full_name = "Tuan Nghia #{i+1}"
    u.password = "123123"
    u.password_confirmation = "123123"
    u.role = "user"
  end
  puts "User account created: #{user.email}"
end

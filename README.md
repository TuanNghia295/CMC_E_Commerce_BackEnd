
# Nike Clothing Store – E-Commerce Platform

## 1. Purpose
Build an e-commerce platform for retailing Nike products such as Shoes, Jackets, and T-Shirts, allowing users to browse products, make purchases, process payments, and track orders. The system is designed to be scalable, maintainable, and API-first, supporting both web and mobile in the future.

## 2. Business Objectives
- Provide a smooth online shopping experience
- Support user and order growth
- Easily expand to:
	- Mobile app
	- Promotional programs
	- Loyalty / Membership

## Getting Started

### Prerequisites
- Ruby (>= 3.0)
- Rails (>= 7.0)
- PostgreSQL (hoặc MySQL, tùy cấu hình database)
- Node.js & Yarn (cho asset pipeline nếu dùng)

### Cài đặt & Khởi động dự án
```bash
# Clone repository
git clone <repo-url>
cd E_Commerce_BackEnd

# Cài đặt gem
bundle install

# Cài đặt JavaScript packages (nếu có)
yarn install # hoặc npm install

# Tạo database & migrate
rails db:create db:migrate db:seed

# Chạy server
rails server
```

### Các lệnh hữu ích
- Chạy test: `rails test`
- Rubocop: `bundle exec rubocop`
- Brakeman: `bundle exec brakeman`

### Đường dẫn truy cập
- Trang chủ: http://localhost:3000
- API docs: docs/api/README.md

---

## Project Documentation Structure

Các tài liệu chi tiết được chia thành các thư mục:

- **docs/workflow/**: System workflow design (user flow, order lifecycle, async/sync với RabbitMQ)
- **docs/api/**: API Documentation
- **docs/architecture/**: High Level Architecture Diagram

Bạn có thể cập nhật, bổ sung các file tài liệu vào từng thư mục này để mở rộng hoặc chi tiết hoá dự án.

---

## ERD
![ERD](docs/erd.png)

---

## License
MIT
- **Week 5:** Checkout Flow, Mock Payment Integration
- **Week 6:** Order Management, Shipping Tracking (basic), Admin Dashboard (basic)
- **Week 7:** Integration Testing, Bug Fixing, Prepare Deployment Plan
- **Week 8:** Final QA, Deployment, Complete Documentation (BRD, Architecture, API)

---


## Getting Started

### Prerequisites
- Ruby (>= 3.0)
- Rails (>= 8.0)
- PostgreSQL (or MySQL, based on database configuration)
- Node.js & Yarn (cho asset pipeline nếu dùng)

### Setup & Run Project
```bash
# Clone repository
git clone <repo-url>
cd E_Commerce_BackEnd

# Gem install
bundle install

# Javasript package install (optional)
yarn install # hoặc npm install

# Create database & migrate
rails db:create db:migrate db:seed

# Run server
rails server
```

### Commands
- Run test: `rails test`
- Rubocop: `bundle exec rubocop`
- Brakeman: `bundle exec brakeman`

### Link
- Homepage: http://localhost:3000
- API docs: ()

---

## ERD
![ERD](docs/erd.png)

---

## License
MIT

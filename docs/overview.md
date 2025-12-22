# Nike Clothing Store – E-Commerce Platform

## 1. Purpose
Build a fullstack e-commerce platform for retailing Nike products (Shoes, Jackets, T-Shirts).
The system is API-first, scalable, and designed to support both web and mobile clients.

---

## 2. Business Objectives
- Provide a smooth online shopping experience
- Support user and order growth
- Enable future expansion:
  - Mobile application
  - Promotion campaigns
  - Loyalty / Membership programs

---

## 3. System Overview

| Layer | Technology |
|------|-----------|
| Frontend | Web (React, TailWindCSS)|
| Backend | Ruby on Rails (API-only) |
| Database | PostgreSQL |
| Cache / Session | Redis |
| Message Queue | RabbitMQ |
| Auth | JWT (Access + Refresh) |

---

## 4. Project Documentation

### 📘 Backend Documentation
- 👉 [API Documentation](../docs/backend/api/README.md)
- 👉 [Backend Architecture](../docs/architecture/backend_architecture.md)
- 👉 [Order & Payment Workflow](../docs/workflow/order_flow.md)
- 👉 [Security & Authentication](../docs/backend/security.md)

### 🎨 Frontend Documentation
- 👉 [Frontend Architecture](../docs/architecture/frontend_architecture.md)
- 👉 [Pages & User Flow](../docs/frontend/pages.md)
- 👉 [Auth Flow (FE ↔ BE)](../docs/frontend/auth-flow.md)
- 👉 [State Management](../docs/frontend/state-management.md)

### 🏗 System Design
- 👉 [High Level Architecture](../docs/architecture/high_level.md)
- 👉 [ERD Diagram](../docs/images/erd.png)
- 👉 [User Flow](../docs/frontend/pages.md)
- 👉 [Order Lifecycle](../docs/workflow/order_lifecycle.md)
- 👉 [Async Processing (RabbitMQ)](../docs/workflow/async_processing.md)


---

## 5. Getting Started (Backend)

### Prerequisites
- Ruby >= 3.0
- Rails >= 8.0
- PostgreSQL
- Node.js & Yarn (optional)

### Setup
```bash
git clone <repo-url>
cd E_Commerce_BackEnd

bundle install
rails db:create db:migrate db:seed
rails server
```

---
## Useful Commands
```bash
Test: rails test
Lint: bundle exec rubocop
Security scan: bundle exec brakeman
```

## License

MIT

---

👉 Continue with:
- [Documentation Index](./README.md)

# 📘 API Documentation – Nike Clothing Store

Base URL: `/api/v1`

Authentication: **JWT (Access + Refresh)**

---

## 📌 API Summary

| Module | Description |
|------|-------------|
| Auth | Authentication & Authorization |
| Users | User profile management |
| Products | Product listing & detail |
| Cart | Shopping cart |
| Orders | Order & order lifecycle |
| Payments | Payment processing |
| Admin | Admin management |

---

## 🔐 Authentication APIs

| Method | Endpoint | Description | Auth |
|------|---------|-------------|------|
| POST | `/auth/register` | Register new user | ❌ |
| POST | `/auth/login` | User login | ❌ |
| POST | `/auth/refresh` | Refresh access token | ❌ |
| POST | `/auth/logout` | Logout user | ✅ |

---

## 👤 User APIs

| Method | Endpoint | Description | Auth |
|------|---------|-------------|------|
| GET | `/users/me` | Get current user profile | ✅ |
| PUT | `/users/me` | Update profile | ✅ |

---

## 👟 Product APIs

| Method | Endpoint | Description | Auth |
|------|---------|-------------|------|
| GET | `/products` | List products | ❌ |
| GET | `/products/:id` | Product detail | ❌ |
| GET | `/categories` | List categories | ❌ |

---

## 🛒 Cart APIs

| Method | Endpoint | Description | Auth |
|------|---------|-------------|------|
| GET | `/cart` | View cart | ✅ |
| POST | `/cart/items` | Add item to cart | ✅ |
| PUT | `/cart/items/:id` | Update cart item | ✅ |
| DELETE | `/cart/items/:id` | Remove item | ✅ |

---

## 📦 Order APIs

| Method | Endpoint | Description | Auth |
|------|---------|-------------|------|
| POST | `/orders` | Create order | ✅ |
| GET | `/orders` | List user orders | ✅ |
| GET | `/orders/:id` | Order detail | ✅ |
| POST | `/orders/:id/cancel` | Cancel order | ✅ |

---

## 💳 Payment APIs

| Method | Endpoint | Description | Auth |
|------|---------|-------------|------|
| POST | `/payments/checkout` | Checkout order | ✅ |
| POST | `/payments/webhook` | Payment webhook | ❌ |

---

## 🛠 Admin APIs

| Method | Endpoint | Description | Auth |
|------|---------|-------------|------|
| GET | `/admin/products` | Manage products | ✅ (Admin) |
| POST | `/admin/products` | Create product | ✅ (Admin) |
| PUT | `/admin/products/:id` | Update product | ✅ (Admin) |
| DELETE | `/admin/products/:id` | Delete product | ✅ (Admin) |

---

## 📎 Notes
- All responses are in JSON
- Errors follow standard HTTP status codes
- Pagination supported on listing endpoints


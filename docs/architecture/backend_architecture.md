# Backend Architecture

## 1. Overview
The backend is built with Ruby on Rails, following an API-first, scalable, and maintainable architecture. It is designed to support both web and mobile clients, and to be easily extensible for future features such as loyalty programs and third-party integrations.

## 2. Main Components
- **API Layer:**
  - Handles RESTful JSON APIs for all business domains (authentication, products, cart, orders, payments, shipping, admin).
  - JWT-based authentication and role-based authorization (guest, customer, admin).
- **Business Logic Layer:**
  - Implements all business rules: cart merging, inventory locking, order/payment/shipping status transitions, etc.
- **Persistence Layer:**
  - Uses ActiveRecord ORM with PostgreSQL.
  - Main tables: users, products, categories, carts, cart_items, orders, order_items, payments, shipments, inventories, order_events, etc.
- **Background Jobs:**
  - Handles asynchronous tasks: sending emails, updating inventory, notifications, etc. (Sidekiq/Resque/ActiveJob).
- **Event/Message Queue:**
  - Supports RabbitMQ or Redis Pub/Sub for async processing (e.g., order_created, payment_success events).
- **Admin Interface:**
  - Allows management of products, categories, inventory, orders, users, and sales statistics.

## 3. Core Business Flows
- **User Authentication & Authorization:**
  - Registration, login, JWT/refresh token management, role assignment.
- **Product Catalog:**
  - CRUD for products and categories, status management, inventory tracking.
- **Shopping Cart:**
  - Add/remove/edit items, merge guest cart on login, persist cart per user.
- **Checkout & Payment:**
  - Inventory check and lock, order creation, mock payment processing, payment status update.
- **Order Management:**
  - Order status transitions, event sourcing for order lifecycle, admin management.
- **Shipping Tracking:**
  - Shipment creation, status updates, basic tracking for users.
- **Admin Dashboard:**
  - System-wide management and reporting.

## 4. Security & Non-functional Requirements
- AES-256 encryption for sensitive user data.
- Strict role-based access control.
- Logging and audit trails for critical actions.
- High performance and scalability (caching, background jobs, horizontal scaling).
- 99.9% uptime target.

## 5. Extensibility & Out of Scope
- Easily extendable for real payment gateways, advanced loyalty, third-party shipping, and mobile apps in the future.
- Out of scope for initial phase: real payment gateway, advanced loyalty, third-party shipping, mobile app.

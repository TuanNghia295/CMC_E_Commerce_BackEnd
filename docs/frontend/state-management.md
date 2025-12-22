# State Management

## 1. Overview
This e-commerce platform uses a client-server model, where the frontend (web/mobile) manages local state and synchronizes with the backend via RESTful APIs. Key states include cart, user authentication, user profile, order status, and inventory.

## 2. Frontend State
- **Authentication State:**
  - Stores JWT/refresh tokens in localStorage or cookies.
  - Determines login status and user role (guest, customer, admin).
- **Cart State:**
  - For guests: cart is stored locally (localStorage).
  - For logged-in users: cart is synced with backend; guest cart is merged on login.
- **User Profile State:**
  - Stores user info (name, email, role, etc.) after login.
- **Order State:**
  - Tracks order status (created, paid, shipped, delivered, cancelled).
- **UI State:**
  - Manages loading, error, and modal states.

## 3. Backend State
- **Session/User State:**
  - Authenticates via JWT/refresh token; user info is available in request context.
- **Cart State:**
  - Each user has a cart (carts, cart_items tables); supports merging guest cart on login.
- **Order State:**
  - Orders and their status are tracked (orders, order_items, order_events tables).
- **Inventory State:**
  - Inventory is locked and checked in real-time during checkout to prevent overselling.
- **Payment/Shipping State:**
  - Payment and shipping statuses are tracked and updated as the order progresses.

## 4. State Synchronization
- On login, guest cart is merged into the user's backend cart.
- All order, payment, and shipping status changes are updated by the backend and fetched by the frontend via API.
- Real-time updates (optional): can use webhooks, websockets, or polling for order/shipping status.

## 5. Technologies
- **Frontend:** Redux, Context API (React), Pinia/Vuex (Vue), or similar state management libraries.
- **Backend:** Rails ActiveRecord, Redis (for session/token cache if needed), event sourcing for order_events.

## 6. Business Rules in State Management
- Prevent checkout if product is out of stock or price changes.
- Guest must register before checkout; temporary cart is merged.
- An order can only have one payment status.
- Inventory is locked during checkout.
- Order cannot be edited after successful payment.



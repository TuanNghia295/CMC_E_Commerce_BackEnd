# Order Lifecycle

![Order Lifecycle](../images/order_lifecycle.png)

## 🎯 Objective
- Avoid half-completed orders
- Ensure clear order state transitions
- Simplify debugging, retry, and recovery
- Enable future expansion (payment, shipping, refund)

---

## 🔄 Order States

### 1. Order Initiation
- `created`

### 2. Payment Phase
- `payment_pending`
- `payment_success`
- `payment_failed`

### 3. Fulfillment Phase
- `confirmed`
- `preparing`
- `shipping`

### 4. Completion Phase
- `delivered`
- `cancelled`

---

## ⚠ Rules
- Order cannot move backward between phases
- Payment failure keeps order in a retryable state
- Cancellation is allowed only before shipping

---

## 🧠 Design Rationale
- Order lifecycle acts as a **state machine**
- Prevents inconsistent order data
- Easy to plug in new payment providers

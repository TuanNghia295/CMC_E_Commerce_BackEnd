# Sync vs Async Processing (RabbitMQ)

![Sync vs Async Flow](../../images/sync_async_flow.png)

## 🎯 Objective
- Reduce API response time
- Separate core business logic from side effects
- Prepare system for horizontal scaling

---

## 🔄 Synchronous Flow
- Validate cart
- Validate stock
- Process payment
- Create order

⏱ Must complete before responding to user

---

## ⚙ Asynchronous Flow
Triggered by event: `order_created`

### Handled by workers:
- Send confirmation email
- Update inventory
- Push notifications
- Logging & analytics

---

## 🧠 Why RabbitMQ?
- Loose coupling between services
- Retry & fault tolerance
- Easy to add new consumers without touching core logic

---

## 📌 Event Example
```json
{
  "event": "order_created",
  "order_id": 123,
  "user_id": 45
}
```


# System Workflow Design

## 1. User Flow Diagram
![User Flow](workflow/user-flow.png)

## 2. Order Lifecycle (Sync/Async)
![Order Lifecycle](workflow/order-lifecycle.png)

## 3. Order Processing Sequence (RabbitMQ)
![Order Sequence](workflow/order-sequence.png)

---

### Mô tả
- User Flow: Quy trình mua hàng từ khi vào website đến khi hoàn tất đơn hàng và tracking shipping.
- Order Lifecycle: Các trạng thái đơn hàng từ tạo, thanh toán, xác nhận, giao hàng, hoàn thành hoặc huỷ.
- Sequence Diagram: Luồng xử lý đơn hàng giữa các service (Frontend, Backend, Payment, Message Queue, Worker).

Bạn có thể cập nhật thêm hình ảnh hoặc mô tả chi tiết vào thư mục này bất cứ lúc nào.
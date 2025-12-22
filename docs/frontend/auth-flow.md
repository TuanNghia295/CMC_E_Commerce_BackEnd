# Authentication Flow (Frontend ↔ Backend)

## 1. Overview

This document describes the **authentication flow** between the Frontend and Backend using **JWT-based authentication** (Access Token + Refresh Token).

The goal is to:
- Secure API access
- Minimize token exposure
- Support seamless token refresh without interrupting user experience

---

## 2. Authentication Strategy

- **Access Token**
  - Short-lived
  - Used to authorize API requests
  - Sent via `Authorization: Bearer <token>`

- **Refresh Token**
  - Long-lived
  - Used only to obtain a new access token
  - Never exposed to application logic

---

## 3. Authentication Flow (Step-by-Step)

### Step 1: User Login
The user submits login credentials via the frontend login form.

### Step 2: Backend Authentication
The backend validates credentials and returns:
- Access Token
- Refresh Token

### Step 3: Token Storage
- Access token is stored **in memory** (or temporary storage)
- Refresh token is stored securely (e.g. HttpOnly Cookie)

### Step 4: Authorized API Requests
All protected API requests include the access token in the request header.

### Step 5: Token Refresh
When the access token expires:
- Frontend sends refresh token to the backend
- Backend issues a new access token
- User session continues without re-login

---

## 4. Authentication Flow Diagram

```text
+---------------------------+
| 1. User submits login     |
|    form                   |
+-------------+-------------+
              |
              v
+---------------------------+
| 2. Backend validates      |
|    credentials and        |
|    returns tokens         |
|   - Access Token          |
|   - Refresh Token         |
+-------------+-------------+
              |
              v
+---------------------------+
| 3. Frontend stores        |
|    Access Token           |
|    (memory / temp store)  |
+-------------+-------------+
              |
              v
+---------------------------+
| 4. API requests include   |
|    Authorization header   |
|    Bearer <Access Token>  |
+-------------+-------------+
              |
              v
+---------------------------+
| 5. Access token expires   |
|    → Refresh token used   |
|    → New access token     |
+---------------------------+
```
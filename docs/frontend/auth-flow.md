# Authentication Flow (Frontend ↔ Backend)

1. User submits login form
2. Backend returns access & refresh token
3. Access token stored in memory / storage
4. API requests include Authorization header
5. Refresh token used when access token expires

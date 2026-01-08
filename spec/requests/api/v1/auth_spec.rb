require 'rails_helper'

describe 'Auth API', type: :request do
  let!(:user) { User.create!(email: 'user@example.com', password: '123123', full_name: 'Test User', role: 'user') }
  let!(:admin) { User.create!(email: 'admin@example.com', password: '123123', full_name: 'Admin User', role: 'admin') }

  describe 'User Auth' do
    describe 'POST /api/v1/auth/register' do
      it 'registers a new user and returns tokens' do
        post '/api/v1/auth/register', params: {
          email: 'newuser@example.com',
          password: '123123',
          password_confirmation: '123123',
          full_name: 'New User'
        }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['access_token']).to be_present
        expect(body['refresh_token']).to be_present
      end

      it 'fails with missing params' do
        post '/api/v1/auth/register', params: { email: '' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'POST /api/v1/auth/login' do
      it 'logs in with valid credentials' do
        post '/api/v1/auth/login', params: { email: user.email, password: '123123' }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['access_token']).to be_present
        expect(body['refresh_token']).to be_present
      end

      it 'fails with wrong password' do
        post '/api/v1/auth/login', params: { email: user.email, password: 'wrong' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST /api/v1/auth/refresh' do
      it 'refreshes access token with valid refresh token' do
        post '/api/v1/auth/login', params: { email: user.email, password: '123123' }
        refresh_token = JSON.parse(response.body)['refresh_token']

        post '/api/v1/auth/refresh', params: { refresh_token: refresh_token }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['access_token']).to be_present
      end

      it 'fails with invalid refresh token' do
        post '/api/v1/auth/refresh', params: { refresh_token: 'invalid' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST /api/v1/auth/logout' do
      it 'revokes refresh token on logout' do
        post '/api/v1/auth/login', params: { email: user.email, password: '123123' }
        refresh_token = JSON.parse(response.body)['refresh_token']

        post '/api/v1/auth/logout', params: { refresh_token: refresh_token }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully')

        # refresh token should be revoked
        token_record = user.refresh_tokens.find_by(token: refresh_token)
        expect(token_record.revoked_at).to be_present
      end
    end
  end

  describe 'Admin Auth' do
    describe 'POST /api/v1/admin/auth/login' do
      it 'logs in admin with valid credentials' do
        post '/api/v1/admin/auth/login', params: { email: admin.email, password: '123123' }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['access_token']).to be_present
        expect(body['refresh_token']).to be_present
        expect(body['user']['role']).to eq('admin')
      end

      it 'fails login if not admin' do
        post '/api/v1/admin/auth/login', params: { email: user.email, password: '123123' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST /api/v1/admin/auth/logout' do
      it 'revokes admin refresh token on logout' do
        post '/api/v1/admin/auth/login', params: { email: admin.email, password: '123123' }
        refresh_token = JSON.parse(response.body)['refresh_token']

        post '/api/v1/admin/auth/logout', params: { refresh_token: refresh_token }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully')

        token_record = admin.refresh_tokens.find_by(token: refresh_token)
        expect(token_record.revoked_at).to be_present
      end
    end
  end
end

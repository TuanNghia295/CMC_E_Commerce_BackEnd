require 'rails_helper'

describe 'Auth API', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', full_name: 'Test User') }

  describe 'POST /api/v1/auth/register' do
    it 'registers a new user and returns tokens' do
      post '/api/v1/auth/register', params: {
        email: 'newuser@example.com',
        password: 'password',
        password_confirmation: 'password',
        full_name: 'New User'
      }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['access_token']).to be_present
    end

    it 'fails with missing params' do
      post '/api/v1/auth/register', params: { email: '' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /api/v1/auth/login' do
    it 'logs in with valid credentials' do
      post '/api/v1/auth/login', params: { email: user.email, password: 'password' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['access_token']).to be_present
    end

    it 'fails with wrong password' do
      post '/api/v1/auth/login', params: { email: user.email, password: 'wrong' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/auth/logout' do
    it 'logs out with valid access and refresh token' do
      post '/api/v1/auth/login', params: { email: user.email, password: 'password' }
      access_token = JSON.parse(response.body)['access_token']
      refresh_token = response.cookies['refresh_token']
      post '/api/v1/auth/logout', headers: {
        'Authorization' => "Bearer #{access_token}",
        'Cookie' => "refresh_token=#{refresh_token}"
      }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Logged out successfully')
    end
  end

  describe 'POST /api/v1/auth/refresh' do
    it 'refreshes token with valid refresh token' do
      post '/api/v1/auth/login', params: { email: user.email, password: 'password' }
      refresh_token = response.cookies['refresh_token']
      post '/api/v1/auth/refresh', headers: { 'Cookie' => "refresh_token=#{refresh_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['access_token']).to be_present
    end

    it 'fails with invalid refresh token' do
      post '/api/v1/auth/refresh', headers: { 'Cookie' => "refresh_token=invalid" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  it 'cannot login with missing password' do
    post '/api/v1/auth/login', params: { email: user.email }
    expect(response).to have_http_status(:unauthorized)
  end

  it 'cannot register with duplicate email' do
    User.create!(email: 'dup@example.com', password: 'password', full_name: 'Dup')
    post '/api/v1/auth/register', params: {
      email: 'dup@example.com',
      password: 'password',
      password_confirmation: 'password',
      full_name: 'Dup'
    }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'revokes old refresh token after refresh' do
    post '/api/v1/auth/login', params: { email: user.email, password: 'password' }
    refresh_token = response.cookies['refresh_token']
    old_token = user.refresh_tokens.last
    post '/api/v1/auth/refresh', headers: { 'Cookie' => "refresh_token=#{refresh_token}" }
    old_token.reload
    expect(old_token.revoked_at).to be_present
  end
end

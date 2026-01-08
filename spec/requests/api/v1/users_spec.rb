# spec/requests/api/v1/admin/users_spec.rb
require "rails_helper"


# PUT/PATCH
RSpec.describe "Admin::Users API", type: :request do
  let!(:user) { create(:user) }

  describe "PUT /api/v1/admin/users/:id" do
    context "when data is valid" do
      let(:params) do
        {
          user: {
            full_name: "Updated Name",
            role: "admin"
          }
        }
      end

      it "updates user successfully" do
        put "/api/v1/admin/users/#{user.id}", params: params

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["user"]["full_name"]).to eq("Updated Name")
        expect(json["user"]["role"]).to eq("admin")

        # verify DB
        user.reload
        expect(user.full_name).to eq("Updated Name")
      end
    end

    context "when data is invalid" do
      it "returns error" do
        put "/api/v1/admin/users/#{user.id}", params: {
          user: { role: "super_admin" }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

    # SOFT DELETE
    describe "DELETE /api/v1/admin/users/:id" do
    it "soft deletes the user" do
      delete "/api/v1/admin/users/#{user.id}"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["message"]).to eq("User deleted successfully")

      user.reload
      expect(user.deleted_at).not_to be_nil
      expect(user).to be_deleted
    end
  end

    # DELETE DOES NOT EXIST
    describe "DELETE /api/v1/admin/users/:id" do
    it "returns 404 when user not found" do
      delete "/api/v1/admin/users/999999"

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json["message"]).to eq("User not found")
    end
  end
end

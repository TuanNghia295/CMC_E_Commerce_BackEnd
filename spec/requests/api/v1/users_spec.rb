# spec/requests/api/v1/admin/users_spec.rb
require "rails_helper"


# PUT/PATCH
RSpec.describe "Admin::Users API", type: :request do
let!(:user) { create(:user, role: "admin") }
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


  # SEARCH, FILTER, SORT
  describe "Search & filter users" do
    let!(:user1) do
      create(:user,
        full_name: "Nguyen Van A",
        created_at: "2024-12-05"
      )
    end

    let!(:user2) do
      create(:user,
        full_name: "Tran Van B",
        created_at: "2024-12-20"
      )
    end

    it "searches by name" do
      get "/api/v1/admin/users", params: { q: "Nguyen" }

      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(1)
      expect(json["data"][0]["full_name"]).to include("Nguyen")
    end

    it "filters by created_at range" do
      get "/api/v1/admin/users", params: {
        from_date: "2024-12-01",
        to_date: "2024-12-10"
      }

      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(1)
    end

    it "sorts A-Z by full_name" do
      get "/api/v1/admin/users", params: {
        sort_by: "full_name",
        sort_dir: "asc"
      }

      json = JSON.parse(response.body)
      names = json["data"].map { |u| u["full_name"] }
      expect(names).to eq(names.sort)
    end

    it "sorts Z-A by full_name" do
      get "/api/v1/admin/users", params: {
        sort_by: "full_name",
        sort_dir: "desc"
      }

      json = JSON.parse(response.body)
      names = json["data"].map { |u| u["full_name"] }
      expect(names).to eq(names.sort.reverse)
    end
  end

  # PAGINATION
  describe "Pagination" do
    before do
      create_list(:user, 25)
    end

    it "returns paginated users" do
      get "/api/v1/admin/users", params: {
        page: 1,
        per_page: 10
      }

      json = JSON.parse(response.body)

      expect(json["data"].size).to eq(10)
      expect(json["meta"]["page"]).to eq(1)
      expect(json["meta"]["total_pages"]).to eq(3)
      expect(json["meta"]["total_count"]).to eq(25)
    end
  end
end




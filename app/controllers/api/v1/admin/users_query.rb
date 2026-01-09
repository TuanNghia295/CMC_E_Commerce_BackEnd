module Api
  module V1
    module Admin
      class UsersQuery
        def initialize(params = {})
          @params = params
        end
        # Kết quả trả về của phương thức trước sẽ là đối tượng thực thi cho phương thức tiếp theo.
        def call
          User
            .active
            .search(@params[:q])
            .filter_by_created_at(@params[:from_date], @params[:to_date])
            .sort_alphabet(@params[:sort_by], @params[:sort_dir])
        end
      end
    end
  end
end

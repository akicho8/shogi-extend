module Api
  module Wkbk
    class ApplicationController < ::Api::ApplicationController
      include SortMethods
      include PageMethods

      class WkbkPermissionError < StandardError; end

      def sort_column_default
        :updated_at
      end

      # |----------+------+--------+-------------+-----------------------------|
      # | 種類     | 一覧 | 直リン | 一覧条件    | 直リン表示条件              |
      # |----------+------+--------+-------------+-----------------------------|
      # | 公開     | ○   | ○     | public_only | true                        |
      # | 限定公開 | ×   | ○     | public_only | true                        |
      # | 非公開   | ×   | ×     | public_only | current_user == record.user |
      # |----------+------+--------+-------------+-----------------------------|
      def show_can!(record)
        if force_access?
          return
        end

        if !record.show_can(current_user)
          raise WkbkPermissionError
        end
      end

      # 管理者であれば force=true で非公開の問題を参照できる
      # http://localhost:4000/rack/books/4?force=true
      def force_access?
        if params[:force] == "true"
          if current_user
            current_user.permit_tag_list.include?("staff")
          end
        end
      end

      # def edit_permission_valid!(record)
      #   raise "must not happen" if !current_user
      #   if record.user != current_user
      #     raise WkbkPermissionError
      #   end
      # end

      rescue_from "ActiveRecord::RecordNotFound" do |error|
        render json: { statusCode: 404, message: "または権限がありません" }, status: :not_found
      end

      rescue_from "WkbkPermissionError" do |error|
        render json: { statusCode: 403, message: "非公開" }, status: 403
      end
    end
  end
end

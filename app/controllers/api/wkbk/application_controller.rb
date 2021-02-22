module Api
  module Wkbk
    class ApplicationController < ::Api::ApplicationController
      include SortMod
      include PageMod

      class WkbkPermissionError < StandardError; end

      def sort_column_default
        :updated_at
      end

      # before_action :api_login_required
      def api_login_required
        unless current_user
          render json: { statusCode: 403, message: "ログインしてください" }, status: 403
        end
      end

      # |----------+------+--------+-------------+-----------------------------|
      # | 種類     | 一覧 | 直リン | 一覧条件    | 直リン表示条件              |
      # |----------+------+--------+-------------+-----------------------------|
      # | 公開     | ○   | ○     | public_only | true                        |
      # | 限定公開 | ×   | ○     | public_only | true                        |
      # | 非公開   | ×   | ×     | public_only | current_user == record.user |
      # |----------+------+--------+-------------+-----------------------------|
      def show_can!(record)
        # 管理者であれば force=true で非公開の問題を参照できる
        # http://0.0.0.0:4000/rack/books/4?force=true
        if params[:force] == "true"
          if current_user
            if current_user.permit_tag_list.include?("staff")
              return
            end
          end
        end

        unless record.show_can(current_user)
          raise WkbkPermissionError
        end
      end

      # def edit_permission_valid!(record)
      #   raise "must not happen" unless current_user
      #   unless record.user == current_user
      #     raise WkbkPermissionError
      #   end
      # end

      rescue_from "ActiveRecord::RecordNotFound" do |error|
        render json: { statusCode: 404, message: "または権限がありません" }, status: 404
      end

      rescue_from "WkbkPermissionError" do |error|
        render json: { statusCode: 403, message: "非公開" }, status: 403
      end
    end
  end
end

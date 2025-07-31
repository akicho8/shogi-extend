# ~/src/shogi-extend/nuxt_side/layouts/error.vue

module Swars
  class BattlesController
    concern :RescueMod do
      included do
        rescue_from "Swars::Agent::BaseError" do |exception|
          AppLog.critical(exception)
          render json: { message: exception.message }, status: exception.status
        end

        rescue_from "Swars::InvalidKey" do |exception|
          render json: { message: exception.message }, status: :not_found
        end

        rescue_from "ActiveRecord::RecordNotFound" do |error|
          render json: { message: "対応するデータが見つかりません" }, status: :not_found
        end

        # "Faraday::ServerError"      → Faraday の raise_error middleware で出るもの
        # "Faraday::ConnectionFailed" → Faraday の raise_error middleware を使わない場合でもこの例外は発生する
        rescue_from "Faraday::ServerError", "Faraday::ConnectionFailed" do |exception|
          AppLog.critical(exception, data: exception.response)
          message = [
            "将棋ウォーズ本家がぶっこわれました",
            "しばらくしてからアクセスすると直るかもしれません",
            exception.message,
          ].collect(&:presence).join("<br>")
          render json: { message: message }, status: :request_timeout
        end

        rescue_from "ActiveRecord::RecordNotUnique" do |exception| # 中身は「Mysql2::Error: Duplicate entry」
          AppLog.info(exception)
          render json: { message: "連打したのでぶっこわれました" }, status: :internal_server_error
        end

        rescue_from "ActiveRecord::Deadlocked" do |exception|
          AppLog.info(exception)
          render json: { message: "データベースが死にそうです" }, status: :internal_server_error
        end
      end
    end
  end
end

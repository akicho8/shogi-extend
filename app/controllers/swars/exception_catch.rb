module Swars
  concern :ExceptionCatch do
    included do
      rescue_from "Swars::Agent::BaseError" do |exception|
        AppLog.critical(exception)
        render json: { message: exception.message }, status: exception.status
      end

      rescue_from "Swars::BattleKeyValidator::InvalidKey" do |exception|
        render json: { message: exception.message }, status: 404
      end

      rescue_from "ActiveRecord::RecordNotFound" do |error|
        render json: { message: "対応するデータが見つかりません" }, status: 404
      end

      rescue_from "Faraday::ConnectionFailed" do |exception|
        AppLog.critical(exception)
        render json: { message: "混み合っています<br>しばらくしてからアクセスしてください" }, status: 408
      end

      rescue_from "ActiveRecord::RecordNotUnique" do |exception| # 中身は「Mysql2::Error: Duplicate entry」
        AppLog.info(exception)
        render json: { message: "連打したのでぶっこわれました" }, status: 500
      end

      rescue_from "ActiveRecord::Deadlocked" do |exception|
        AppLog.critical(exception)
        render json: { message: "データベースが死にそうです" }, status: 500
      end
    end
  end
end

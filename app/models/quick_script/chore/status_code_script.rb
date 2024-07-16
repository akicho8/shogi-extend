module QuickScript
  module Chore
    class StatusCodeScript < Base
      self.title = "ステイタスコード変更"
      self.description = "指定のステイタスコードをクライアントに返す"

      def call
        description
      end

      def status_code
        params[:status_code].try { to_i }
      end

      def primary_error_message
        params[:primary_error_message].presence
      end
    end
  end
end

module Swars
  module Agent
    class BaseError < StandardError
      attr_accessor :status

      def initialize(status = :internal_server_error, message = "(MESSAGE)")
        @status = status
        super(message)
      end
    end

    class SwarsFormatIncompatible < BaseError
      def initialize(message = "将棋ウォーズ本家のデータ構造が変わってしまいました")
        super(:bad_request, message)
      end
    end

    class RaiseConnectionFailed < BaseError
      def initialize(message = "混み合っています<br>しばらくしてからアクセスしよう")
        super(:request_timeout, message)
      end
    end

    class BattleNotFound < BaseError
      def initialize(message = "指定の対局が存在しません<br>URLを間違えていませんか？")
        super(:not_found, message)
      end
    end
  end
end

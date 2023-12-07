module Swars
  module Agent
    class BaseError < StandardError
      attr_accessor :status

      def initialize(status = 500, message = "(MESSAGE)")
        @status = status
        super(message)
      end
    end

    class SwarsFormatIncompatible < BaseError
      def initialize(message = "将棋ウォーズ本家のデータ構造が変わってしまいました")
        super(400, message)
      end
    end

    class RaiseConnectionFailed < BaseError
      def initialize(message = "混み合っています<br>しばらくしてからアクセスしてください")
        super(408, message)
      end
    end

    class SwarsBattleNotFound < BaseError
      def initialize(message = "指定の対局が存在しません<br>URLを間違えていませんか？")
        super(404, message)
      end
    end
  end
end

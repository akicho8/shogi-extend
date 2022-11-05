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
      def initialize(*)
        super(400, "将棋ウォーズ本家のデータ構造が変わってしまいました")
      end
    end

    class SwarsConnectionFailed < BaseError
      def initialize(status = nil, message = nil)
        super(408, "混み合っています<br>しばらくしてからアクセスしてください")
      end
    end

    class SwarsUserNotFound < BaseError
      def initialize(status = nil, message = nil)
        super(404, "ウォーズIDが存在しません<br>大文字と小文字を間違えていませんか？")
      end
    end

    class SwarsBattleNotFound < BaseError
      def initialize(status = nil, message = nil)
        super(404, "指定の対局が存在しません<br>URLを間違えていませんか？")
      end
    end
  end
end

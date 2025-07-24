module QuickScript
  module Dev
    class TopBottomContentScript < Base
      self.title = "上に表示する"
      self.description = "必ずフォームより上に表示する (body の表示位置を入れ替えるのとは違う)"

      def top_content
        "(#{__method__})"
      end

      def call
        "(#{__method__})"
      end

      def bottom_content
        "(#{__method__})"
      end
    end
  end
end

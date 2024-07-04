module QuickScript
  module Dev
    class HtmlScript < Base
      self.title = "HTML表示"
      self.description = "タグで始まると HTML として表示する"

      def call
        "<b>bold</b>"
      end
    end
  end
end

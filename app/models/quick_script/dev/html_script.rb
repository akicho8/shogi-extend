module QuickScript
  module Dev
    class HtmlScript < Base
      self.title = "HTML表示"
      self.description = "タグで始まると HTML として表示する"

      def call
        tag.details { "本文" }
      end
    end
  end
end

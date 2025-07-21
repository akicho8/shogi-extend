module QuickScript
  module Dev
    class HeadContentScript < Base
      self.title = "上に表示する"
      self.description = "必ずフォームより上に表示する (body の表示位置を入れ替えるのとは違う)"

      def head_content
        "(head_content)"
      end
    end
  end
end

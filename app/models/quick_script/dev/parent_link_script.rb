module QuickScript
  module Dev
    class ParentLinkScript < Base
      self.title = "ブラウザバックで戻る挙動のテスト"
      self.description = "外部サイトに出そうなら符号の鬼に移動する例"
      self.form_method = :get
      self.parent_link = { fallback_url: "/xy" }

      def call
        params
      end
    end
  end
end

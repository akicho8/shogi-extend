module QuickScript
  module Dev
    class DelegateScript < Base
      self.title = "特定のコンポーネントに委譲する"
      self.description = "QuickScriptViewComponentSample1 を呼び出す"
      self.navibar_show = false

      def call
        { _component: "QuickScriptViewComponentSample1" }
      end
    end
  end
end

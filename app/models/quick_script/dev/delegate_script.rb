module QuickScript
  module Dev
    class DelegateScript < Base
      self.title = "コンポーネント委譲"
      self.description = "指定したコンポーネントで処理する"

      def call
        { _component: "QuickScriptViewValueAsPre", _v_bind: { value: "コンポーネントに渡す内容" } }
      end
    end
  end
end

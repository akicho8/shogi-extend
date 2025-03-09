module QuickScript
  module Middleware
    concern :ComponentWrapperMod do
      def v_stack(values, **options)
        { _component: "QuickScriptViewValueAsV", _v_bind: { value: values }, **options }
      end

      def h_stack(values, **options)
        { _component: "QuickScriptViewValueAsH", _v_bind: { value: values }, **options }
      end

      def box_block(values, **options)
        { _component: "QuickScriptViewValueAsBox", _v_bind: { value: values }, **options }
      end
    end
  end
end

module QuickScript
  module Middleware
    concern :ComponentWrapperMod do
      def v_stack(...)
        component_wrapper("QuickScriptViewValueAsV", ...)
      end

      def h_stack(...)
        component_wrapper("QuickScriptViewValueAsH", ...)
      end

      def box_block(...)
        component_wrapper("QuickScriptViewValueAsBox", ...)
      end

      def component_wrapper(component, values = nil, **options, &block)
        if values && block_given?
          raise ArgumentError
        end
        if block_given?
          values = yield
        end
        { _component: component, _v_bind: { value: values }, **options }
      end
    end
  end
end

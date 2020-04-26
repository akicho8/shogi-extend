module AtomicScript
  module ExampleScript
    class ArPaggingScript < ::AtomicScript::ExampleScript::Base
      self.script_name = "ARページングのテスト"

      def form_parts
        [
          {
            :label   => "per",
            :key     => :per,
            :type    => :integer,
            :default => params[:per],
          },
        ]
      end

      def script_body
        page_scope(AlertLog)
      end
    end
  end
end

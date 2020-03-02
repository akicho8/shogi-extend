module AtomicScript
  module ExampleScript
    class GetScript < ::AtomicScript::ExampleScript::Base
      self.script_name = "フォームなし"

      def script_body
        "OK"
      end
    end
  end
end

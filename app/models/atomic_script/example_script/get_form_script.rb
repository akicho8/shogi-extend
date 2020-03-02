module AtomicScript
  module ExampleScript
    class GetFormScript < ::AtomicScript::ExampleScript::Base
      self.script_name = "GETフォーム"

      def form_parts
        {
          :label   => "値",
          :key     => :foo,
          :type    => :string,
          :default => params[:foo],
        }
      end

      def script_body
        params
      end
    end
  end
end


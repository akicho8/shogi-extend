module AtomicScript
  module ExampleScript
    class PostFormScript < ::AtomicScript::ExampleScript::Base
      include AtomicScript::PostRedirectMethods

      self.script_name = "POSTフォーム"

      def form_parts
        {
          :label   => "値",
          :key     => :foo,
          :type    => :string,
          :default => params[:foo],
        }
      end

      def script_body
        params.slice(:foo)
      end
    end
  end
end

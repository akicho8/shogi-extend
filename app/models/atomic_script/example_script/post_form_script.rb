module AtomicScript
  module ExampleScript
    class PostFormScript < ::AtomicScript::ExampleScript::Base
      self.script_name = "POSTフォーム"
      self.post_method_use_p = true

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


module AtomicScript
  module ExampleScript
    class PostFormScript < ::AtomicScript::ExampleScript::Base
      include AtomicScript::PostMod

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
        params
      end
    end
  end
end

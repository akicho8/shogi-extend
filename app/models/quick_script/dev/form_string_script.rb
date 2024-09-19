# http://localhost:4000/lab/dev/form-string?user_agent_key=desktop&a=%22%22

module QuickScript
  module Dev
    class FormStringScript < Base
      self.title = "フォーム配列要素"
      self.description = "空文字列を扱う"
      self.form_method = :get

      def form_parts
        super + [
          {
            :label        => "文字列",
            :key          => :x,
            :type         => :string,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :default => params[:x].to_s,
              }
            },
          },
        ]
      end

      def call
        {
          "controller.params[:x]" => controller.params[:x],
          "params[:x]"            => params[:x],
          "scoped_session"        => scoped_session,
        }
      end
    end
  end
end

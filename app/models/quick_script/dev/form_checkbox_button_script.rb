module QuickScript
  module Dev
    class FormCheckboxButtonScript < Base
      self.title = "フォーム配列要素"
      self.description = "GETであっても空配列を空配列として認識させる (空配列として受け取れればセッションで上書きされない)"
      self.form_method = :get

      def form_parts
        super + [
          {
            :label        => "checkbox (array)",
            :key          => :x,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ["a", "b", "c"],
                :default => Array.wrap(params[:x].presence) & ["a", "b", "c"], # elems で and しておかないと不正な値がずっと含まれてしまう
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

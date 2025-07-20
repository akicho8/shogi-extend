module QuickScript
  module Admin
    class AppLogShowScript < Base
      self.title = "アプリログ詳細"
      self.description = "アプリログ詳細を表示する"
      self.form_method = :get
      self.button_label = "詳細"

      def form_parts
        super + [
          {
            :label   => "ID",
            :key     => :id,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:id].presence,
              }
            },
          },
        ]
      end

      def call
        if id = params[:id].presence
          if app_log = AppLog.find_by(id: id)
            attrs = app_log.attributes.clone
            body = attrs.delete("body")
            attrs["body"] = h.tag.pre(body)
            attrs.to_html
          end
        end
      end
    end
  end
end

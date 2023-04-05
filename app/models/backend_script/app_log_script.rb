module BackendScript
  class AppLogScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "アプリログ"

    private

    def form_parts
      [
        {
          :label   => "曖昧検索",
          :key     => :query,
          :type    => :string,
          :default => current_query,
        },
      ]
    end

    def script_body
      s = AppLog.order(:created_at, :id).reverse_order
      if current_query
        s = s.where(["body like ?", "%#{current_query}%"])
      end
      s = page_scope(s)
      rows = s.collect(&method(:row_build))
      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(app_log)
      {
        "ID"   => app_log.id, # script_link_to(app_log.id, :id => "ar_search", :model => current_model.name,:record_id => app_log.id),
        "題名" => app_log.subject,
        "本文" => app_log.body,
        "日時" => app_log.created_at.to_s,
      }
    end

    def current_query
      params[:query].presence
    end
  end
end

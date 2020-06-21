module BackendScript
  class AlertLogScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "アラートログ"

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
      s = AlertLog.order(:created_at, :id).reverse_order
      if current_query
        s = s.where(["body like %?%", current_query])
      end
      s = page_scope(s)
      rows = s.collect(&method(:row_build))
      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(alert_log)
      {
        "ID"   => alert_log.id, # script_link_to(alert_log.id, :id => "ar_search", :model => current_model.name,:record_id => alert_log.id),
        "題名" => alert_log.subject,
        "本文" => alert_log.body,
        "日時" => alert_log.created_at.to_s,
      }
    end

    def current_query
      params[:query].presence
    end
  end
end

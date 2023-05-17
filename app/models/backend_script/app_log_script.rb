module BackendScript
  class AppLogScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "アプリログ"
    self.column_wrapper_enable = false

    private

    def form_parts
      [
        {
          :label   => "検索",
          :key     => :query,
          :type    => :string,
          :default => current_query,
        },
      ]
    end

    def script_body
      s = AppLog.order(:created_at, :id)
      if params[:reverse]
      else
        s = s.reverse_order
      end
      if q = current_query
        s = s.search(q)
      end
      s = page_scope(s)
      rows = s.collect(&method(:row_build))
      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(app_log)
      {
        "ID"       => app_log.id, # script_link_to(app_log.id, :id => "ar_search", :model => current_model.name, :record_id => app_log.id),
        "作成日時" => app_log.created_at.to_fs(:ymdhms),
        "Level"    => app_log.level,
        "絵"       => app_log.emoji,
        "題"       => app_log.subject,
        "本文"     => app_log.body,
      }
    end

    def current_query
      params[:query].presence
    end
  end
end

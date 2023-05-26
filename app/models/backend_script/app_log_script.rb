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
      if id = params[:app_log_id]
        attrs = AppLog.find(id).attributes.clone
        body = attrs.delete("body")
        attrs["body"] = h.tag.pre(body, style: "font-family:monospace")
        return attrs.to_html
      end

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
        "ID"       => script_link_to(app_log.id, :app_log_id => app_log.id, :target => "_blank"),
        "作成日時" => app_log.created_at.to_fs(:ymdhms),
        "Level"    => app_log.level,
        "絵"       => app_log.emoji,
        "題"       => app_log.subject,
        "本文"     => h.auto_link(app_log.body),
      }
    end

    def current_query
      params[:query].presence
    end
  end
end

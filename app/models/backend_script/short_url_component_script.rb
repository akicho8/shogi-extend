module BackendScript
  class ShortUrlComponentScript < ::BackendScript::Base
    self.category = "短縮URL"
    self.script_name = "短縮URL - 直近利用順"
    self.column_wrapper_enable = false

    private

    def script_body
      if id = params[:component_id]
        attrs = ShortUrl::Component.find(id).attributes.clone
        return attrs.to_html
      end

      s = ShortUrl::Component.order(:updated_at).reverse_order
      s = page_scope(s)
      rows = s.collect(&method(:row_build))
      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(component)
      {
        "ID"       => script_link_to(component.id, { :component_id => component.id }, { :target => "_blank" }),
        "作成日時" => component.created_at.to_fs(:ymdhms),
        "更新日時" => component.updated_at.to_fs(:ymdhms),
        "利用回数" => component.access_logs_count,
        "短縮URL"  => h.auto_link(component.compact_url, html: { target: "_blank" }),
        "元URL"    => h.auto_link(component.original_url, html: { target: "_blank" }) { |s| s.truncate(140) },
      }
    end
  end
end

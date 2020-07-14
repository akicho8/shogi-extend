# ・タイトルを表示したくないときは to_title_html を上書きする
# ・または self.page_title = "" とする
module AtomicScript
  concern :PageTitleMod do
    included do
      class_attribute :page_title
    end

    def render_in_view
      (to_title_html || "".html_safe) + super
    end

    def visible_title
      (page_title || script_name).presence
    end

    def to_title_html
      # h.instance_variable_set(:@page_title, script_name)
      # h.tag.div(h.instance_variable_get(:@page_title), :class => "title is-4")
      if v = visible_title
        h.tag.div(v, :class => "title is-3")
      end
    end
  end
end

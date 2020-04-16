# ・タイトルを表示したくないときは to_title_html を上書きする
# ・または self.page_title = "" とする
module AtomicScript
  concern :PageTitleMod do
    included do
      class_attribute :page_title
    end

    def to_title_html
      # h.instance_variable_set(:@page_title, script_name)
      # h.tag.div(h.instance_variable_get(:@page_title), :class => "title is-4")
      if v = (page_title || script_name).presence
        h.tag.div(script_name, :class => "title is-3")
      end
    end
  end
end

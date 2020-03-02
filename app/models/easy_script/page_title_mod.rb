module EasyScript
  concern :PageTitleMod do
    def to_title_html
      # h.instance_variable_set(:@page_title, script_name)
      # h.tag.div(h.instance_variable_get(:@page_title), :class => "title is-4 yumincho")
      h.tag.div(script_name, :class => "title is-4 yumincho")
    end
  end
end

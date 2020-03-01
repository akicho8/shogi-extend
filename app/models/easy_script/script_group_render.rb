# メニューのプルダウンで表示したいとき用
module EasyScript
  concern :ScriptGroupRender do
    def render_html(h, controller)
      bundle_scripts.collect { |e|
        if e.menu_display?
          h.link_to(e.script_name, e.script_link_path, :class => ["navbar-item", ("is-active" if h.params[:controller] == controller && h.params[:id] == e.key)])
        end
      }.compact.join.html_safe
    end
  end
end

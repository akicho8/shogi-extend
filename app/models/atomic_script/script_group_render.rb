# メニューのプルダウンで表示したいとき用
module AtomicScript
  concern :ScriptGroupRender do
    # 主にデバッグ用のリンク
    def to_rows(h)
      bundle_scripts.collect do |e|
        {
          "スクリプト" => h.link_to(e.script_name, e.script_link_path),
          "キー"       => e.key,
        }
      end
    end

    # メニュー表示用リンク
    def to_navbar_items(h, options = {})
      options = {
        controller: /\b(scripts)\b/,
      }.merge(options)

      bundle_scripts.collect { |e|
        if e.menu_display?
          active = h.params[:controller].match?(options[:controller]) && h.params[:id] == e.key

          klass = []
          klass << "block px-4 py-2 text-sm hover:bg-gray-100"
          if active
            klass << "bg-gray-100 font-semibold text-gray-900"
          end
          h.link_to(e.script_name, e.script_link_path, :class => klass)
        end
      }.compact.join.html_safe
    end
  end
end

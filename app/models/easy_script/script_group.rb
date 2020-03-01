module EasyScript
  concern :ScriptGroup do
    # 保持しているスクリプトクラスたちを返す
    # [Frontend::FooScript, Frontend::BarScript, ...]
    def bundle_scripts
      @bundle_scripts ||= keys.collect(&method(:find))
    end

    # def cloud_links(h)
    #   h.content_tag(:ul) do
    #     bundle_scripts.collect {|e|
    #       active = (h.params[:id].to_s == e.key.to_s)
    #       h.content_tag(:li, h.link_to(e.script_name, h.polymorphic_path([:admin, :backend_script], :id => e.key)), :class => active ? "is-active" : nil)
    #     }.join.html_safe
    #   end
    # end

    # キーからクラスへの変換
    # find("foo-bar") => "Frontend::FooBarScript"
    def find(key)
      "#{name}/#{key}_#{name_prefix}".underscore.classify.constantize
    end

    private

    # このクラス名が FooBar なら app/models/foo_bar/*_script.rb がある想定
    def keys
      @keys ||= Pathname("app/models/#{name.underscore}").glob("[^_]*_#{name_prefix}.rb").collect { |e| e.basename(".rb").to_s.remove(/_#{name_prefix}\z/) }.sort
    end

    def name_prefix
      :script
    end
  end
end

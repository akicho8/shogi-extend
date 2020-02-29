module ScriptGroup
  def keys
    @keys ||= script_dirs.flat_map { |dir|
      Pathname(dir).glob("#{name.underscore}/[^_]*_script.rb").collect {|f| f.basename(".rb").to_s.remove(/_script\z/) }
    }.sort
  end

  def bundle_classes
    @bundle_classes ||= keys.collect { |e| script_constantize(e) }
  end

  def find(key)
    "#{name}/#{key}_script".classify.constantize
  end

  # def cloud_links(h)
  #   h.content_tag(:ul) do
  #     bundle_classes.collect {|e|
  #       active = (h.params[:id].to_s == e.key.to_s)
  #       h.content_tag(:li, h.link_to(e.label_name, h.polymorphic_path([:admin, :backend_script], :id => e.key)), :class => active ? "is-active" : nil)
  #     }.join.html_safe
  #   end
  # end

  private

  def script_constantize(key)
    "#{name}/#{key}_script".classify.constantize
  end

  def script_dirs
    [__dir__]
  end
end

module AdminScript
  extend self

  def keys
    admin_scripts_keys.sort.uniq
  end

  def bundle_classes
    @bundle_classes ||= keys.collect { |e| script_constantize(e) }
  end

  def cloud_links(h)
    h.content_tag(:ul, :class => "nav nav-pills") do
      bundle_classes.collect {|e|
        active = (h.params[:id].to_s == e.key.to_s)
        h.content_tag(:li, h.link_to(e.label_name, h.polymorphic_path([:admin, :admin_script], :id => e.key)), :class => active ? "active" : nil)
      }.join.html_safe
    end
  end

  private

  def script_constantize(key)
    "#{name}/#{key}".classify.constantize
  end

  def admin_scripts_keys
    [Rails.root].collect {|dir|
      Pathname.glob("#{dir}/app/models/#{name.underscore}/[^_]*_script.rb").collect {|f| f.basename(".rb").to_s }
    }.flatten
  end
end

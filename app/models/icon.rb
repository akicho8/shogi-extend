module Icon
  extend self
  extend ActionView::Helpers::TagHelper

  # 何もサイズを指定しないと font-size に依存する
  def icon_tag(*keys)
    options = keys.extract_options!
    i = tag.i(:class => [:mdi, *keys.collect { |e| "mdi-#{e.to_s.gsub(/_/, '-')}" }])
    s = tag.span(i, :class => ["icon", options[:size], *options[:class]].flatten.compact)
    "#{s}&nbsp;".html_safe
  end
end

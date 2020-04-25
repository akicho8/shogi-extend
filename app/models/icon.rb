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

  # アイコン指定
  #
  #   fa_icon_tag(:fab, )                                #=> nil
  #   fa_icon_tag(:fab, :clock_o, :fixed_width => false) #=> ' <i class="fa fa-clock-o"></i> '
  #   fa_icon_tag(:fab, :clock_o)                        #=> ' <i class="fa fa-clock-o fa-fw"></i> '
  #   fa_icon_tag(:fab, :clock_o, :size => 1)            #=> ' <i class="fa fa-clock-o fa-fw"></i> '
  #   fa_icon_tag(:fab, :clock_o, :size => 2)            #=> ' <i class="fa fa-clock-o fa-fw fa-lg"></i> '
  #
  def fa_icon_tag(*keys)
    options = {
      :size        => 1,
      :fixed_width => true,
    }.merge(keys.extract_options!)

    size = {
      1 => "",
      2 => "fa-lg",
      3 => "fa-2x",
      4 => "fa-3x",
      5 => "fa-4x",
      6 => "fa-5x",
    }.fetch(options.delete(:size))

    fixed_width = options.delete(:fixed_width) ? "fa-fw" : ""

    klass = keys.drop(1).join(" ").gsub("_", "-").split(/\s+/).collect do |e|
      "fa-#{e}"
    end
    if klass.present?
      options[:class] = [keys.first, *klass, size, fixed_width, options[:class]].join(" ").squish
      (" " + tag.i(options) + " ").html_safe
    end
  end
end

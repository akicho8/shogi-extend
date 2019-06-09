module Icon
  extend self
  extend ActionView::Helpers::TagHelper

  # 何もサイズを指定しないと font-size に依存する
  def icon_tag(*keys)
    options = {
      # debug: Rails.env.development?
    }.merge(keys.extract_options!)

    size = options[:size]

    if size
      # ~/src/shogi_web/node_modules/buefy/src/components/icon/Icon.vue
      # mdi-18px  mdi-24px  mdi-36px  mdi-48px
      table = {
        # "is-small": nil,               # 何も指定しないのがいちばん小さい ← 嘘
        # "is-default": nil,
        # "is-medium": 18,
        # "is-large": 24,
        # "is-large2": 36,
      }
      # if v = table[size]
      #   keys << "#{v}px"
      # end
    end

    rs = options[:margin_right] || 0
    ls = options[:margin_left] || 0

    i_style = nil
    span_style = nil
    if options[:debug]
      i_style = "border: 1px dotted blue"
      span_style = "border: 2px dotted blue"
    end

    i = tag.i(style: i_style, :class => [:mdi, *keys.collect { |e| "mdi-#{e.to_s.gsub(/_/, '-')}" }])
    s = tag.span(i, :class => ["icon", size, *options[:class]].flatten.compact, style: span_style)

    if true
      space = "&nbsp;"
      s = (space * ls).html_safe + s + (space * rs).html_safe
    end

    " #{s} ".html_safe
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

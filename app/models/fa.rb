module Fa
  extend self
  extend ActionView::Helpers::TagHelper

  def icon_tag2(*names)
    options = {
      size: :default,
    }.merge(names.extract_options!)

    if size = options.delete(:size)
      # ~/src/shogi_web/node_modules/buefy/src/components/icon/Icon.vue
      # mdi-18px  mdi-24px  mdi-36px  mdi-48px
      table = {
        small: nil,               # 何も指定しないのがいちばん小さい
        # medium2: 18,
        default: 18,
        medium: 24,
        large: 36,
      }
      if v = table[size.to_sym]
        names << "#{v}px"
      end
    end

    names = names.collect { |e| "mdi-#{e}" }

    space = "&nbsp;"
    if margin_right = options.delete(:margin_right)
      margin_right = space * margin_right
    else
      margin_right = " "
    end

    if margin_left = options.delete(:margin_left)
      margin_left = space * margin_left
    else
      margin_left = " "
    end

    options[:class] = [:mdi, names, options[:class]].compact.join(" ").squish

    margin_left.html_safe + tag.span(options) + margin_right.html_safe
  end

  # アイコン指定
  #
  #   icon_tag(:fab, )                                #=> nil
  #   icon_tag(:fab, :clock_o, :fixed_width => false) #=> ' <i class="fa fa-clock-o"></i> '
  #   icon_tag(:fab, :clock_o)                        #=> ' <i class="fa fa-clock-o fa-fw"></i> '
  #   icon_tag(:fab, :clock_o, :size => 1)            #=> ' <i class="fa fa-clock-o fa-fw"></i> '
  #   icon_tag(:fab, :clock_o, :size => 2)            #=> ' <i class="fa fa-clock-o fa-fw fa-lg"></i> '
  #
  def icon_tag(*names)
    options = {
      :size        => 1,
      :fixed_width => true,
    }.merge(names.extract_options!)

    size = {
      1 => "",
      2 => "fa-lg",
      3 => "fa-2x",
      4 => "fa-3x",
      5 => "fa-4x",
      6 => "fa-5x",
    }.fetch(options.delete(:size))

    fixed_width = options.delete(:fixed_width) ? "fa-fw" : ""

    klass = names.drop(1).join(" ").gsub("_", "-").split(/\s+/).collect do |e|
      "fa-#{e}"
    end
    if klass.present?
      options[:class] = [names.first, *klass, size, fixed_width, options[:class]].join(" ").squish
      (" " + tag.i(options) + " ").html_safe
    end
  end
end

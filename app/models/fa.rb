module Fa
  extend self
  extend ActionView::Helpers::TagHelper

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

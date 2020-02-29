# 設定方法
#
#   class ApplicationController < ActionController::Base
#     helper FormBox::Helper
#   end
#

module ViewSupportHelper
  def form_box_example_form_parts
    FormBox.example_str_form_parts.collect { |e| eval(e) }
  end

  # <span class="label label-default">Default</span>
  # <span class="label label-primary">Primary</span>
  # <span class="label label-success">Success</span>
  # <span class="label label-info">Info</span>
  # <span class="label label-warning">Warning</span>
  # <span class="label label-danger">Danger</span>
  def bootstrap_label_tag(name, options = {})
    if v = options[:color].presence || :default
      if Rails.env.development? || Rails.env.test?
        if [:default, :primary, :success, :info, :warning, :danger].exclude?(v.to_sym)
          raise ArgumentError, [name, color].inspect
        end
      end
      name = content_tag(:span, name, :class => "label label-#{v}")
    end
    name
  end

  # tooltip と popover を簡単に指定するためのヘルパー
  # tooltip を popover に変換するが面倒すぎるために作成
  #
  # bootstrap_tooltip_options(:tooltip => "a")               # => rel=tooltip title=a
  # bootstrap_tooltip_options(:tooltip => "a", :body => "b") # => rel=popover title=a data-content=b
  #
  def bootstrap_tooltip_options(info)
    attrs = {}
    if info[:tooltip]
      if info[:toolbody]
        attrs.update(:rel => "popover", :title => info[:tooltip], :data => {:content => info[:toolbody]})
      else
        attrs.update(:rel => "tooltip", :title => info[:tooltip])
      end
    end
    attrs
  end

  def bootstrap_page_header_tag(title, sub_title: nil)
    if title.presence
      if s = sub_title.presence
        title = title.html_safe + " ".html_safe + content_tag(:small, s.html_safe)
      end
      title = content_tag(:h2, title)
      bootstrap_page_header(title)
    end
  end

  # bootstrap_label_tag を p で囲んだもの
  def bootstrap_label_p_tag(*args)
    content_tag(:p, bootstrap_label_tag(*args))
  end

  # :tag => :pre にすると等幅になる
  def bootstrap_alert(str, options = {})
    options = options.dup
    type = options.delete(:type)
    tag = options.delete(:tag) || :div
    raise ArgumentError, "#{type.inspect}" unless type.to_s.in?(["success", "info", "warning", "danger"])
    type = "alert-#{type}"
    content_tag(tag, str, options.merge(:class => "alert #{type}"))
  end

  def bootstrap_error_with_backtrace(error)
    bootstrap_alert(["#{error.class.name}: #{error.message}", "", *error.backtrace].join("<br/>").html_safe, :tag => :pre, :type => :danger)
  end

  def bootstrap_error(error)
    bootstrap_alert("#{error.class.name}: #{error.message}", :tag => :pre, :type => :danger)
  end

  #
  # シンプルなリストの作成
  #
  def bootstrap_list(list, options = {})
    options = {
      :class => "list-unstyled",
    }.merge(options)
    out = "".html_safe
    out << content_tag(:ul, options) do
      list.collect {|e| content_tag(:li, e)}.join.html_safe
    end
    out
  end

  # アイコン指定
  #
  #   bootstrap_icon()                                #=> nil
  #   bootstrap_icon(:clock_o, :fixed_width => false) #=> ' <i class="fa fa-clock-o"></i> '
  #   bootstrap_icon(:clock_o)                        #=> ' <i class="fa fa-clock-o fa-fw"></i> '
  #   bootstrap_icon(:clock_o, :size => 1)            #=> ' <i class="fa fa-clock-o fa-fw"></i> '
  #   bootstrap_icon(:clock_o, :size => 2)            #=> ' <i class="fa fa-clock-o fa-fw fa-lg"></i> '
  #
  def bootstrap_icon(*names)
    options = {
      :size        => 2,
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

    klass = names.join(" ").gsub("_", "-").split(/\s+/).collect {|e| "fa-#{e}"}
    if klass.present?
      options[:class] = [:fa, *klass, size, fixed_width, options[:class]].join(" ").squish
      (" " + content_tag(:i, "", options) + " ").html_safe
    end
  end

  [
    {:name => :bootstrap_page_header,   :tag => :div, :options => {:class => "page-header" }, },
    {:name => :bootstrap_controls,      :tag => :div, :options => {:class => "controls"    }, },
    {:name => :bootstrap_control_group, :tag => :div, :options => {:class => "form-group"  }, },
  ].each {|attrs|
    define_method(attrs[:name]) do |content = nil, options = {}, &block|
      if block
        options = content || {}
        content = capture(&block)
      else
        content
      end
      content_tag(attrs[:tag], content, attrs[:options].merge(options))
    end
  }

  def bootstrap_form_actions(content = nil, &block)
    content_tag(:div, :class => "form-group") do
      content_tag(:div, :class => "col-md-offset-2 col-md-10") do
        if block
          capture(&block)
        else
          content
        end
      end
    end
  end
end

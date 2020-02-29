module FormBox
  module InputBuilder
    class Base
      attr_accessor :params

      def initialize(params)
        @params = {
          :inline      => false, # 横並びにしたいときに指定すると幅をつっぱらなくなる
          :left_width  => 2,     # 左側のセル数
        }.merge(params)
      end

      def input_render
        if params[:hidden]
          return TypeHidden.new(params).input_render
        end

        h.content_tag(:div, :class => "field") do |;out|
          out = "".html_safe
          out << label_build
          out << h.tag.div(tag_build, :class => "control")
          # right_content = [hidden_build, tag_build, help_build(params)].compact.join.html_safe
          # right_content = h.content_tag(:div, right_content, :class => "col-md-#{params[:right_width] || default_right_width}")
          # out << right_content
          out
        end
      end

      private

      def h
        ::ApplicationController.helpers
      end

      def hidden_build
        if params[:freeze]
          h.hidden_field_tag(key, default)
        end
      end

      def default_right_width
        10 # 右側のセル幅
      end

      def i18n_label
        label = params[:label]
        unless label
          if s = I18n.t("attributes.#{params[:key]}", :default => "").presence
            label = s
          else
            label = params[:key]
          end
        end
        label
      end

      def i18n_label_with_tooltip
        v = i18n_label
        if o = label_tooltip_options.presence
          v = h.content_tag(:span, v, o)
        end
        v
      end

      def label_build
        h.label_tag(key, i18n_label_with_tooltip, label_html_options)
      end

      def label_html_options
        o = {}
        # unless params[:inline]
        # o[:class] = "label col-md-#{params[:left_width]}"
        o[:class] = "label"
        # end
        o
      end

      def label_tooltip_options
        o = {}
        if params[:tooltip]
          e = params.dup
          if e[:tooltip] == true
            e = e.merge(:tooltip => e[:key])
          end
          o.update(h.bootstrap_tooltip_options(e))
        end
        o
      end

      # radioボタンではこちらを使う
      def html_options
        options = {
          :required    => params[:required],
          :placeholder => params[:placeholder],
          :disabled    => params[:freeze],
        }.merge(params[:html_options] || {})

        class_add(options, options[:class])
      end

      def form_controll
        html_options.merge(:class => [*html_options[:class], "input"].join(" ").squish.split)
      end

      # help-inline は Bootstrap3 で廃止
      def help_build(params)
        s = ""
        if v = params[:help_message]
          s << h.content_tag(:span, v, :class => "help-block")
        end
        s.html_safe
      end

      def key
        if params[:prefix]
          [params[:prefix], "[", params[:key], "]"].join
        else
          params[:key]
        end
      end

      def default
        params[:default]
      end

      def class_add(hash, css_class)
        hash.merge(:class => [hash[:class], css_class].join(" ").split(/\s+/).uniq.join(" "))
      end
    end
  end
end

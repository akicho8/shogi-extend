module EasyScript
  concern :SupportMod do
    included do
    end

    class_methods do
    end

    def bold(str)
      h.tag.b(str)
    end

    def invisible(key)
      h.tag.span(key, :style => "display:none")
    end

    # タグを取ったとき他の数値と混ざらないように [] で囲む
    def sort_value(value)
      h.content_tag(:span, "[#{key}]", :style => "display:none")
    end

    def current_page
      params[:page].presence.to_i
    end

    def page_per(s)
      if v = current_per.presence
        s = s.page(current_page).per(v)
      end
      s
    end

    def current_per
      v = (params[:per].presence || 25).to_i
      if v.positive?
        v
      end
    end

    def form_part_per
      [
        {
          :label        => "1ページあたりの行数",
          :key          => :per,
          :type         => :integer,
          :default      => params[:per],
          :collapse     => params[:per].blank?,
          :placeholder  => current_per,
          :help_message => "0以下を指定するとページングしなくなるので件数が多いモデルの場合は気をつけてください",
        },
      ]
    end

    # def span_nowrap(value)
    #   if value.present?
    #     h.content_tag(:span, value, :class => "text-nowrap")
    #   end
    # end
    #
    # def div_nowrap(value)
    #   if value.present?
    #     h.content_tag(:div, value, :class => "text-nowrap")
    #   end
    # end

    # def help_message_tag_links(klass, tags_key = :tags)
    #   tags = klass.tag_counts_on(tags_key, :at_least => 1, :limit => 256)
    #   names = tags.collect(&:name)
    #   names.collect { |e| h.link_to(e, "#", :class => "tag_link button button-link") }.join(" ").html_safe
    # end

    # def __tooltip(name, tooltip = nil)
    #   if v = tooltip.presence
    #     name = h.content_tag(:span, name, h.bootstrap_tooltip_options(:tooltip => v))
    #   end
    #   name
    # end

    concern :FormPartPerAppend do
      def form_parts
        super + form_part_per
      end
    end

    concerning :Parent do
      def other_response_params
        {}
      end
    end

    concerning :MenuHelper do
      class_methods do
        def to_menu_element(h, params = {}, **options)
          {
            :name     => (options[:name] || script_name),
            :url      => script_link_path(params),
            # :if_match => {:controller => Admin::FrontScriptsController, :id => key},
          }
        end
      end
    end
  end
end

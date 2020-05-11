module AtomicScript
  concern :SupportMod do
    def bold(str)
      h.tag(:class => "has-text-weight-bold") { str }
    end

    def small(str)
      h.tag(:class => "is-size-7") { str }
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

    concern :FormPartPerAppend do
      def form_parts
        super + form_part_per
      end
    end
  end
end

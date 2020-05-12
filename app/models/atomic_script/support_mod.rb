module AtomicScript
  concern :SupportMod do
    included do
      include PageMod
    end

    def bold(str)
      h.tag(:class => "has-text-weight-bold") { str }
    end

    def small(str)
      h.tag(:class => "is-size-7") { str }
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
  end

  concern :FormPartPerAppend do
    def form_parts
      super + form_part_per
    end
  end
end

module AtomicScript
  concern :SupportMethods do
    included do
      include PageMethods

      def default_per
        200
      end
    end

    def bold(str)
      h.tag.span(:class => "has-text-weight-bold") { str }
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

module ShareBoard
  class MessageScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :is_message_scope_public,  }, # name: "全体",     label: "送信", icon: "play", type: "is-primary", class: "", title_emoji: "",   toast_type: "is-white",   message_class: nil,               },
      { key: :is_message_scope_private, }, # name: "観戦者宛", label: "観戦", icon: "play", type: "is-success", class: "", title_emoji: "🙊", toast_type: "is-success", message_class: "has-text-success" },
    ]

    # class << self
    #   def lookup(v)
    #     if v.kind_of?(String)
    #       v = StringUtil.hankaku_format(v)
    #     end
    #     super || invert_table[v]
    #   end
    #
    #   private
    #
    #   def invert_table
    #     @invert_table ||= inject({}) do |a, e|
    #       a.merge({
    #           e.swars_magic_key => e,
    #           e.name           => e,
    #           e.long_name      => e,
    #         })
    #     end
    #   end
    # end
    #
    # def short_name
    #   name
    # end
    #
    # def real_life_time
    #   super || life_time
    # end
  end
end

if $0 == __FILE__
  p ShareBoard::MessageScopeInfo[""].name
end

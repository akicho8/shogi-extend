module ShareBoard
  class SenderInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        :key => :bot,
        :default_options_fn => -> {
          {
            :real_user_id => ::User.bot.id,
            **ChatAi::GptProfile.new.messanger_options,
          }
        },
      },
      {
        :key => :sysop,
        :default_options_fn => -> {
          {
            :real_user_id   => ::User.sysop.id,
            :from_user_name => "運営",
          }
        },
      },
    ]
  end
end

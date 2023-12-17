module ShareBoard
  class SenderInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        :key => :bot,
        :default_options_fn => -> {
          {
            :session_user_id   => ::User.bot.id,
            :from_user_name => "GPT",
            :primary_emoji  => "🤖",
          }
        },
      },
      {
        :key => :admin,
        :default_options_fn => -> {
          {
            :session_user_id   => ::User.admin.id,
            :from_user_name => "運営",
          }
        },
      },
    ]
  end
end

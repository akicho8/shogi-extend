# ▼発言を返す
# rails r 'ShareBoard::Responder2.new(message: "励まして").call'
module ShareBoard
  class Responder2
    attr_accessor :params

    delegate :logger, to: :Rails

    def initialize(params = {})
      @params = {
        room_code: "dev_room",
      }.merge(params.symbolize_keys)
    end

    def call
      if user_raw_message.present?
        history << user_message
      end
      topic = history.to_topic
      topic.unshift(system_message)
      text = ChatGptClient.new(topic).call
      if text
        history << Message.new(:assistant, text)
        logger.debug { history.to_topic.to_t }
        SystemMailer.notify(fixed: true, subject: "ChatGPT 返答記録 (#{room_code})", body: history.to_topic.to_t).deliver_later
        messanger.call(text)
      end
    end

    private

    def room_code
      params[:room_code]
    end

    def messanger
      Messenger.new(messanger_options)
    end

    def history
      @history ||= MessageHistory.new(room_code: room_code)
    end

    def user_message
      Message.new(:user, user_raw_message)
    end

    def user_raw_message
      params[:message]
    end

    def message_scope_key
      params[:message_scope_key] || :is_message_scope_public
    end

    def system_message
      Message.new(:system, system_raw_message)
    end

    def system_raw_message
      "
あなたは将棋が好きで将棋ウォーズでよく遊んでいます。
現在はまだ4級ですが将来はプロ棋士を目指しています。
あなたは菅井竜也先生に憧れています。
一人称は「小生」です。
堅苦しい言葉を使わず、友達のような感覚で会話してください。
発言は80文字以内にしてください。
"
    end

    def messanger_options
      {
        :room_code         => room_code,
        :from_user_name    => "GPT",
        :primary_emoji     => "🤖",
        :message_scope_key => message_scope_key,
      }
    end
  end
end

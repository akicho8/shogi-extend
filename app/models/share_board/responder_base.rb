# ▼発言を返す
# rails r 'ShareBoard::Responder.new(message: "@gpt 将棋ウォーズの棋力は？").call'
module ShareBoard
  class ResponderBase
    GPT_NAME     = "gpt"
    MATCH_REGEXP = /\A\s*@#{GPT_NAME}(?!\w+)\s*|\s*[>＞]\s*#{GPT_NAME}\s*\z/i

    attr_accessor :params

    delegate :logger, to: :Rails

    def initialize(params = {})
      @params = {
        room_code: "dev_room",
      }.merge(params.symbolize_keys)
    end

    def response_generate
      begin
        topic = history.to_topic
        topic.unshift(system_message)
        text = ChatGptClient.new(topic).call
        if text
          history << Message.new(:assistant, text)
          logger.debug { history.to_topic.to_t }
          AppLog.important(subject: "ChatGPT 返答記録 (#{room_code})", body: history.to_topic.to_t)
          messanger.call(text)
        end
      rescue Net::ReadTimeout => error
        # 例外をスルーしてしまうと Sidekiq がリトライを繰り返すことになるため例外は潰しておく
        # あとで送信できたとしても会話が食い違うので一度目で失敗したらリトライは不要
        AppLog.critical(error)
      end
    end

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
      Message.new(:user, normalized_user_message)
    end

    def normalized_user_message
      user_raw_message.remove(MATCH_REGEXP)
    end

    def user_raw_message
      params[:message]
    end

    def message_scope_key
      params[:message_scope_key] || :is_message_scope_public
    end

    def system_message
      Message.new(:system, GptProfile.new.system_raw_message)
    end

    def messanger_options
      {
        :room_code         => room_code,
        :message_scope_key => message_scope_key,
        **GptProfile.new.messanger_options,
      }
    end
  end
end

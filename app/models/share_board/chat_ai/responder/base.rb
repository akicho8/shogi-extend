# 発言を返す
#
#   rails r 'ShareBoard::Responder::Responder.new(message: "@gpt 将棋ウォーズの棋力は？").call'
#
# - ChotMessage に依存してはいけない
# - 現在の雑談内容をもとに新しい発言をするので ChotMessage と 1:1 の関係ではない
# - 発言ではなく部屋と 1:1 の関係になる
module ShareBoard
  module ChatAi
    module Responder
      class Base
        GPT_NAME     = "gpt"
        MATCH_REGEXP = /\A\s*@#{GPT_NAME}(?!\w+)\s*|\s*[>＞]\s*#{GPT_NAME}\s*\z/i

        attr_accessor :params

        delegate :logger, to: :Rails

        # params = {
        #   "from_connection_id"=>"espq1cQtyB3",
        #   "from_user_name"=>"alice",
        #   "performed_at"=>1678970689204,
        #   "ua_icon_key"=>"mac",
        #   "ac_events_hash"=>{"initialized"=>1,
        #     "connected"=>2,
        #     "received"=>16,
        #     "disconnected"=>1},
        #   "debug_mode_p"=>true,
        #   "from_avatar_path"=>"/assets/human/0005_fallback_avatar_icon-f076233f605139a9b8991160e1d79e6760fe6743d157446f88b12d9dae5f0e03.png",
        #   "message"=>"@gpt hello",
        #   "message_scope_key"=>"is_message_scope_public",
        #   "action"=>"message_share",
        #   :room_code=>"dev_room",
        # }
        def initialize(params = {})
          @params = {
            room_code: "dev_room",
          }.merge(params.symbolize_keys)
        end

        def call
          raise NotImplementedError, "#{__method__} is not implemented"
        end

        def normalized_user_message
          user_raw_message.remove(MATCH_REGEXP)
        end

        private

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

        def messanger
          Messenger.new(messanger_options)
        end

        def history
          @history ||= MessageHistory.new(room_code: room_code)
        end

        def user_message
          Message.new(:user, normalized_user_message)
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

        # 必要なパラメータは以下だけ

        def room_code
          params[:room_code]
        end

        def user_raw_message
          params[:message]
        end

        def message_scope_key
          params[:message_scope_key] || :is_message_scope_public
        end

        # class MessagerGpt
        # end
      end
    end
  end
end

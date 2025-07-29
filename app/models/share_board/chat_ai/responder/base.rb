# 発言を返す
#
#   rails r 'ShareBoard::Responder::Responder.new(content: "@gpt 将棋ウォーズの棋力は？").call'
#
# - ChatMessage に依存してはいけない
# - 現在の雑談内容をもとに新しい発言をするので ChatMessage と 1:1 の関係ではない
# - 発言ではなく部屋と 1:1 の関係になる
module ShareBoard
  module ChatAi
    module Responder
      class Base
        begin
          GPT_PREFIX = /(?:@|＠)/
          GPT_NAME = /(?:GPT|ＧＰＴ)/i

          # 本来は @gpt hello と書いてほしい。Twitter でもそうなっている。
          # しかし、スペースを入れる重要さを理解できてない人がいるため仕方なく @gpthello にも対応する
          if false
            # @gpt hello
            MATCH_REGEXP_TWITTER_LIKE = /\A\s*#{GPT_PREFIX}#{GPT_NAME}(?!\w+)\s*/i
          else
            # @gpthello
            MATCH_REGEXP_TWITTER_LIKE = /\A\s*#{GPT_PREFIX}#{GPT_NAME}\s*/i
          end

          MATCH_REGEXP_REDIRECT = /\s*[>＞]\s*#{GPT_NAME}\s*\z/i

          MATCH_REGEXP = Regexp.union(MATCH_REGEXP_TWITTER_LIKE, MATCH_REGEXP_REDIRECT)
        end

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
        #   "content"=>"@gpt hello",
        #   "message_scope_key"=>"ms_public",
        #   "action"=>"message_share",
        #   :room_key=>"dev_room",
        # }
        def initialize(params = {})
          @params = {
            room_key: "dev_room",
          }.merge(params.symbolize_keys)
        end

        def call
          raise NotImplementedError, "#{__method__} is not implemented"
        end

        def normalized_message_content
          message_content.remove(MATCH_REGEXP)
        end

        private

        def response_generate
          begin
            topic = history.to_topic
            topic.unshift(system_message)
            text = ChatAiClient.new(topic).call
            if text
              history << Message.new(:assistant, text)
              logger.debug { history.to_topic.to_t }
              AppLog.info(subject: "ChatGPT 返答記録 (#{room_key})", body: history.to_topic.to_t(truncate: 80))
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
          @history ||= MessageHistory.new(room_key: room_key)
        end

        def user_message
          Message.new(:user, normalized_message_content)
        end

        def system_message
          Message.new(:system, AiProfile.system_raw_message)
        end

        def messanger_options
          {
            :room_key          => room_key,
            :message_scope_key => message_scope_key,
            **SenderInfo.fetch(:bot).default_options_fn.call,
          }
        end

        # 必要なパラメータは以下だけ

        def room_key
          params[:room_key]
        end

        def message_content
          params[:content]
        end

        def message_scope_key
          params[:message_scope_key] || :ms_public
        end
      end
    end
  end
end

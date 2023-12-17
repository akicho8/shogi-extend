# link: nuxt_side/components/ShareBoard/chat/mod_chat_iob.js

module ShareBoard
  class Room::ChatMessageLoader
    def initialize(room, params)
      @room = room
      @params = params
    end

    # GET http://localhost:3000/api/share_board/chat_message_loader?room_key=dev_room&limit=2
    # GET http://localhost:3000/api/share_board/chat_message_loader?room_key=xxx
    # GET http://localhost:3000/api/share_board/chat_message_loader?room_key=dev_room&mock=true
    # GET https://www.shogi-extend.com/api/share_board/chat_message_loader?room_key=5%E6%9C%88%E9%8A%80%E6%B2%B3%E6%88%A6
    def as_json
      if @params[:mock]
        @room.setup_for_test(force: true, count: 100)
      end

      AppLog.debug(subject: subject, body: body)

      hv = {}
      hv.update(root_attributes)
      hv[:previous_seek_pos] = current_seek_pos       # JS側から来た seek_pos (デバッグ用)
      hv[:next_seek_pos]     = next_seek_pos          # [2, 3] を返すとしたら 2 が入っているので次に seek_pos に 2 を入れて呼ばせる
      hv[:has_next_p]        = has_next_p             # 次があるか？ 2未満 (つまり 0 か 1) があれば true
      hv[:data_exist_p]      = chat_messages.present? # 今回データを取得できたか？
      hv[:page_index]        = current_page_index     # JS側から来た page_index (デバッグ用)
      hv[:chat_messages]     = chat_messages.as_json(ChatMessage::JSON_TYPE1)
      hv
    end

    private

    def subject
      "発言履歴取得API(#{@room.key})(#{current_user_name})"
    end

    def body
      "[#{current_page_index}] #{current_seek_pos || '?'}未満から#{current_limit || '?'}件取得した結果 #{chat_messages.collect(&:id)} を返す (次:#{has_next_p ? '有' : '無'})"
    end

    def root_attributes
      @room.as_json({only: [:id, :key, :chat_messages_count]}) # どれも確認のためだけに入れている
    end

    def chat_messages
      @chat_messages ||= yield_self do
        s = @room.chat_messages
        s = s.includes(user: nil, message_scope: nil, session_user: nil)
        s = s.order(id: :desc)
        if v = current_limit
          s = s.limit(v)
        end
        if v = current_seek_pos
          s = s.where(ChatMessage.arel_table[:id].lt(v)) # seek_pos 未満のデータを拾う
        end
        s = s.reverse
      end
    end

    # 次があるか？
    def has_next_p
      return @has_next_p if defined?(@has_next_p)
      @has_next_p ||= yield_self do
        if v = next_seek_pos
          s = @room.chat_messages
          s = s.order(id: :desc)
          s.where(ChatMessage.arel_table[:id].lt(v)).exists?
        end
      end
      @has_next_p = !!@has_next_p
    end

    # 次にアクセスするときに渡してほしい seek_pos の値
    def next_seek_pos
      if chat_messages.empty?
        # ここで nil を返してしまうと JS 側で seek_pos が null になり初回アクセスと同じ状態になってしまう。
        # そのため空のときは今回渡されたままにしておく
        # こうすると JS 側の処理がシンプルになる
        current_seek_pos
      else
        # 次から最上位のIDを渡してほしいため
        if e = chat_messages.first
          e.id
        end
      end
    end

    def current_limit
      if v = @params[:limit]
        v.to_i
      end
    end

    def current_seek_pos
      if v = @params[:seek_pos]
        v.to_i
      end
    end

    def current_page_index
      if v = @params[:page_index]
        v.to_i
      end
    end

    def current_user_name
      @params[:user_name]
    end
  end
end

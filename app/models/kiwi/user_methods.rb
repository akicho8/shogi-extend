# user = User.create!
# lemon = user.kiwi_lemons.create!
# lemon.articles << user.kiwi_articles.create!(key: "a")
# lemon.articles << user.kiwi_articles.create!(key: "b")

module Kiwi
  module UserMethods
    extend ActiveSupport::Concern

    concerning :LemonMethods do
      included do
        has_many :kiwi_lemons, class_name: "Kiwi::Lemon", dependent: :destroy

        # このユーザーが作成した本(複数)
        has_many :kiwi_books, class_name: "Kiwi::Book", dependent: :destroy do
          def create_mock1(attrs = {})
            create!(attrs) do |e|
              e.title ||= SecureRandom.hex
              e.description ||= SecureRandom.hex
            end
          end
        end
      end

      # 自分が所有していて完了したもの
      def kiwi_my_lemons_singlecast
        bc_params = {
          # :my_records => lemons.done_only.limit(5).order(created_at: :desc).as_json(Kiwi::Lemon.json_struct_for_list),
          :my_records => kiwi_lemons.limit(Kiwi::Lemon.user_history_max).order(created_at: :desc).as_json(Kiwi::Lemon.json_struct_for_list),
        }
        Kiwi::LemonRoomChannel.broadcast_to(self, {bc_action: :kiwi_my_lemons_singlecasted, bc_params: bc_params})
      end

      # 終了したもの
      def kiwi_done_lemon_singlecast(done_record, params = {})
        bc_params = {
          :done_record => done_record.as_json(Kiwi::Lemon.json_struct_for_done_record),
          :noisy => true,
          **params,
        }
        Kiwi::LemonRoomChannel.broadcast_to(self, {bc_action: :kiwi_done_lemon_singlecasted, bc_params: bc_params})
      end

      # 進捗
      def kiwi_progress_singlecast(bc_params)
        Kiwi::LemonRoomChannel.broadcast_to(self, {bc_action: :kiwi_progress_singlecasted, bc_params: bc_params})
      end
    end

    concerning :BookMessageMethods do
      included do
        with_options dependent: :destroy do
          # has_many :kiwi_room_messages,     class_name: "Kiwi::RoomMessage"
          # has_many :kiwi_lobby_messages,    class_name: "Kiwi::LobbyMessage"
          has_many :kiwi_book_messages, class_name: "Kiwi::BookMessage"
        end
      end

      # # rails r 'User.sysop.lobby_speak(Time.current)'
      # def lobby_speak(body, options = {})
      #   kiwi_lobby_messages.create!({body: body}.merge(options))
      # end

      # # rails r 'User.sysop.room_speak(Kiwi::Room.first, Time.current)'
      # def room_speak(room, body, options = {})
      #   kiwi_room_messages.create!({room: room, body: body}.merge(options))
      # end

      # rails r 'User.sysop.kiwi_book_message_speak(Kiwi::Book.first, Time.current)'
      def kiwi_book_message_speak(book, body, options = {})
        kiwi_book_messages.create!({book: book, body: body}.merge(options))
      end

      def kiwi_book_message_pong_singlecast
        Kiwi::BookRoomChannel.broadcast_to(self, {bc_action: :kiwi_book_message_pong_singlecast, bc_params: {pong: "OK"}})
      end
    end

    concerning :AccessLogMethods do
      included do
        with_options dependent: :destroy do
          has_many :kiwi_access_logs, class_name: "Kiwi::AccessLog" do                                         # アクセスログたち
            # 動画の視聴履歴(重複なし・直近順)
            def foobar123
              s = select(:book_id, "MAX(created_at) as last_access_at").group(:book_id)
              max = 100
              s = s.order("last_access_at desc").limit(max)
              ids = s.collect(&:book_id)
              Book.where(id: ids).order([Arel.sql("FIELD(#{Book.primary_key}, ?)"), ids])
            end
          end
          has_many :kiwi_access_books, through: :kiwi_access_logs, source: :book, class_name: "Kiwi::Book"   # 過去に見た履歴動画
        end

        # scope :kiwi_book_histories, -> {
        #   s = kiwi_access_books.select(:book_id, "MAX(created_at) as last_access_at").group(:book_id)
        #   s = s.order("last_access_at desc").limit(100)
        #   ids = s.collect(&:book_id)
        #   Book.where(id: ids).order([Arel.sql("FIELD(#{Book.primary_key}, ?)"), ids])
        # }
      end

      def kiwi_access_log_pong_singlecast
        Kiwi::BookRoomChannel.broadcast_to(self, {bc_action: :kiwi_access_log_pong_singlecast, bc_params: {pong: "OK"}})
      end
    end
  end
end

# http://localhost:4000/lab/admin/share_board_chat_message_search

module QuickScript
  module Admin
    class ShareBoardChatMessageSearchScript < Base
      self.title = "【共有将棋盤】発言"
      self.description = "共有将棋盤の発言の情報を表示する"

      def top_content
        room_ids = ShareBoard::ChatMessage.where(created_at: 24.hours.ago..).distinct.pluck(:room_id)
        h_stack(style: "gap: 0.5rem") do
          ShareBoard::Room.find(room_ids).collect do |room|
            { _nuxt_link: room.key, _v_bind: { to: qs_nuxt_link_to(params: { room_id: room.id }) }, :class => "button is-small is-light" }
          end
        end
      end

      def call
        pagination_for(current_scope, always_table: true) do |scope|
          scope.collect do |e|
            {}.tap do |row|
              row["ID"] = e.id
              row["部屋"] = { _nuxt_link: e.room.key, _v_bind: { to: qs_nuxt_link_to(params: { room_id: e.room.id }), }, }
              row["名前"] = { _nuxt_link: e.user.name, _v_bind: { to: qs_nuxt_link_to(params: { user_id: e.user.id }), }, }
              row["発言"] = { _autolink: e.strip_tagged_content }
              row["日時"] = e.created_at.to_fs(:ymdhms)
            end
          end
        end
      end

      def current_scope
        scope = ShareBoard::ChatMessage.all
        if v = params[:room_id]
          scope = scope.where(room_id: v)
        end
        if v = params[:user_id]
          scope = scope.where(user_id: v)
        end
        if false
          scope = scope.where(created_at: 24.hours.ago..)
        end
        scope = scope.includes(:user, :room)
        scope = scope.order(created_at: :desc, id: :desc)
      end
    end
  end
end

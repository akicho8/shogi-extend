# http://localhost:4000/lab/admin/share_board_room_search

module QuickScript
  module Admin
    class ShareBoardRoomSearchScript < Base
      self.title = "【共有将棋盤】部屋"
      self.description = "共有将棋盤の部屋の情報を表示する"

      def call
        pagination_for(current_scope, always_table: true) do |scope|
          scope.collect do |e|
            {}.tap do |row|
              row["ID"] = e.id
              row["名前"] = e.key
              row["対局数"] = { _nuxt_link: e.battles_count, _v_bind: { to: qs_nuxt_link_to(qs_page_key: "share_board_battle_search", params: { room_id: e.id }), }, }
              row["発言数"] = { _nuxt_link: e.chat_messages_count, _v_bind: { to: qs_nuxt_link_to(qs_page_key: "share_board_chat_message_search", params: { room_id: e.id }), }, }
              row["作成"] = e.created_at.to_fs(:ymdhms)
              row["更新"] = e.updated_at.to_fs(:ymdhms)
              row["ランキング"] = { _link_to: "ランキング", _v_bind: { href: e.to_share_board_dashboard_url, target: "_blank" }, }
              row["入室"] = { _link_to: "入室", _v_bind: { href: e.to_share_board_url, target: "_blank" }, }
              row["面子"] = h_stack do
                e.users.collect do |user|
                  { _nuxt_link: "#{user.name}(#{user.memberships_count})", _v_bind: { to: qs_nuxt_link_to(params: { user_id: user.id }), }, }
                end
              end
            end
          end
        end
      end

      def current_scope
        scope = ShareBoard::Room.all
        if v = params[:id]
          scope = scope.where(id: v)
        end
        if v = params[:user_id]
          scope = scope.where(roomships: {user: v})
        end
        scope = scope.includes(roomships: :user, users: nil)
        scope = scope.order(updated_at: :desc)
      end
    end
  end
end

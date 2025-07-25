# http://localhost:4000/lab/admin/share_board_battle_index

module QuickScript
  module Admin
    class ShareBoardBattleIndexScript < Base
      self.title = "共有将棋盤対局履歴"
      self.description = "共有将棋盤の対局の履歴一覧を表示する"

      def call
        current_scope.order(created_at: :desc).limit(50).collect do |e|
          {}.tap do |row|
            row["ID"] = { _link_to: e.id, _v_bind: { href: e.to_share_board_url, target: "_blank" }, }
            # row["部屋"] = { _nuxt_link: e.room.key, _v_bind: { to: qs_nuxt_link_to(params: { key: e.room.key }), }, }
            row["部屋"] = { _nuxt_link: e.room.key, _v_bind: { to: qs_nuxt_link_to(params: { room_id: e.room.id }), }, }
            row["日時"] = e.created_at.to_fs(:ymdhms)
            row["手数"] = e.turn
            Bioshogi::Location.each do |location|
              row[location.pentagon_mark] = v_stack do
                e.public_send(location.key).collect do |membership|
                  { _nuxt_link: "#{membership.user.name}(#{membership.user.memberships.count})", _v_bind: { to: qs_nuxt_link_to(params: { user_id: membership.user.id }), }, }
                end
              end
            end
          end
        end
      end

      def current_scope
        scope = ShareBoard::Battle.all
        if v = params[:room_id]
          scope = scope.where(room_id: v)
        end
        scope
      end
    end
  end
end

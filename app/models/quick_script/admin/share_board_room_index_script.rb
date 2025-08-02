# http://localhost:4000/lab/admin/share_board_room_index

module QuickScript
  module Admin
    class ShareBoardRoomIndexScript < Base
      self.title = "共有将棋盤 部屋"
      self.description = "共有将棋盤の部屋の履歴一覧を表示する"

      def call
        current_scope.collect do |e|
          {}.tap do |row|
            row["ID"] = e.id
            row["部屋"] = { _nuxt_link: "#{e.key}(#{e.battles.size})", _v_bind: { to: qs_nuxt_link_to(qs_page_key: "share_board_battle_index", params: { room_id: e.id }), }, }
            row["作成"] = e.created_at.to_fs(:ymdhms)
            row["更新"] = e.updated_at.to_fs(:ymdhms)
            row["履歴"] = { _link_to: "履歴", _v_bind: { href: e.to_share_board_dashboard_url, target: "_blank" }, }
            row["入室"] = { _link_to: "入室", _v_bind: { href: e.to_share_board_url, target: "_blank" }, }
            row["面子"] = h_stack do
              e.memberships.collect do |membership|
                { _nuxt_link: "#{membership.user.name}(#{membership.user.memberships.size})", _v_bind: { to: qs_nuxt_link_to(params: { user_id: membership.user.id }), }, }
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
          scope = scope.where(id: ShareBoard::User.find(v).room_ids)
        end
        scope = scope.order(updated_at: :desc)
        scope = scope.limit(50)
        scope = scope.includes(:battles)
      end
    end
  end
end

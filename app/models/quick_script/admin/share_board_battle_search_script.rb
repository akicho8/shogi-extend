# http://localhost:4000/lab/admin/share_board_battle_search

module QuickScript
  module Admin
    class ShareBoardBattleSearchScript < Base
      self.title = "【共有将棋盤】対局"
      self.description = "共有将棋盤の対局の情報を表示する"

      def call
        pagination_for(current_scope, always_table: true) do |scope|
          scope.collect do |e|
            {}.tap do |row|
              row["ID"] = e.id
              row["部屋情報"] = { _nuxt_link: "↗️", _v_bind: { to: qs_nuxt_link_to(qs_page_key: "share_board_room_search", params: { id: e.room.id }), }, }
              row["部屋"] = { _nuxt_link: "#{e.room.key}(#{e.room.battles.size})", _v_bind: { to: qs_nuxt_link_to(params: { room_id: e.room.id }), }, }
              LocationInfo.each do |location|
                row[location.pentagon_mark] = v_stack do
                  e.public_send(location.key).collect do |membership|
                    { _nuxt_link: "#{membership.user.name}(#{membership.user.memberships.size})", _v_bind: { to: qs_nuxt_link_to(params: { user_id: membership.user.id }), }, }
                  end
                end
              end
              row["日時"] = e.created_at.to_fs(:ymdhms)
              row["棋譜"] = { _link_to: "#{e.turn}手", _v_bind: { href: e.to_share_board_url, target: "_blank" }, }
              row["履歴"] = { _link_to: "履歴", _v_bind: { href: e.room.to_share_board_dashboard_url, target: "_blank" }, }
              row["入室"] = { _link_to: "入室", _v_bind: { href: e.room.to_share_board_url, target: "_blank" }, }
            end
          end
        end
      end

      def current_scope
        scope = ShareBoard::Battle.all
        if v = params[:room_id]
          scope = scope.where(room_id: v)
        end
        if v = params[:user_id]
          scope = scope.where(memberships: { user: v })
        end
        scope = scope.includes(:memberships => { :user => :memberships }, :room => :battles, :black => :user, :white => :user)
        scope = scope.order(created_at: :desc)
      end
    end
  end
end

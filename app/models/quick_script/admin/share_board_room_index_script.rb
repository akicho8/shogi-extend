# http://localhost:4000/lab/admin/share_board_room_index

module QuickScript
  module Admin
    class ShareBoardRoomIndexScript < Base
      self.title = "共有将棋盤 部屋"
      self.description = "共有将棋盤の部屋の履歴一覧を表示する"

      def call
        ShareBoard::Room.order(updated_at: :desc).limit(50).collect do |e|
          {}.tap do |row|
            row["ID"] = e.id
            row["合言葉"] = { _link_to: e.key, _v_bind: { href: e.to_share_board_url, target: "_blank" }, }
            row["作成"] = e.created_at.to_fs(:ymdhms)
            row["更新"] = e.updated_at.to_fs(:ymdhms)
            row["対局数"] = e.battles.count
          end
        end
      end
    end
  end
end

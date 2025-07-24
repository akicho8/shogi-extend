# http://localhost:4000/lab/admin/share_board_battle_index

module QuickScript
  module Admin
    class ShareBoardBattleIndexScript < Base
      self.title = "共有将棋盤対局履歴"
      self.description = "共有将棋盤の対局の履歴一覧を表示する"

      def call
        ShareBoard::Battle.order(created_at: :desc).limit(50).collect do |e|
          {}.tap do |row|
            row["ID"] = e.id
            row["日時"] = e.created_at.to_fs(:ymdhms)
            row["面子"] = e.memberships.collect { |e| e.user.name }.join(", ")
          end
        end
      end
    end
  end
end

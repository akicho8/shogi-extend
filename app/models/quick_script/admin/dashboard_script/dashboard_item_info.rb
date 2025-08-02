module QuickScript
  module Admin
    class DashboardScript
      class DashboardItemInfo
        include ApplicationMemoryRecord
        memory_record [
          {
            name: "[共盤] 接続数",
            href: UrlProxy.full_url_for("/lab/admin/action_cable_info_script".dasherize),
            func: -> { ActionCable.server.open_connections_statistics.count },
          },
          {
            name: "[共盤] 利用状況 (直近1h)",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "共有将棋盤" }),
            func: -> { AppLog.subject_like("共有将棋盤").where(AppLog.arel_table[:created_at].gteq(1.hours.ago)).count },
          },
          {
            name: "[共盤] 対局数 (直近24h)",
            href: UrlProxy.full_url_for("/lab/amdin/share_board_battle_index".dasherize),
            func: -> { ShareBoard::Battle.where(ShareBoard::Battle.arel_table[:created_at].gteq(24.hours.ago)).count },
          },
          {
            name: "[共盤] 発言数 (直近24h)",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "チャット" }),
            func: -> { AppLog.subject_like("チャット").where(AppLog.arel_table[:created_at].gteq(24.hours.ago)).count },
          },

          ################################################################################

          {
            name: "[ウ検] 検索数 (直近1h)",
            func: -> { ::Swars::SearchLog.where(::Swars::SearchLog.arel_table[:created_at].gteq(1.hours.ago)).count },
          },
          {
            name: "[ウ検] 検索数 (直近24h)",
            func: -> { ::Swars::SearchLog.where(::Swars::SearchLog.arel_table[:created_at].gteq(24.hours.ago)).count },
          },
          {
            name: "[ウ検] 取込対局数 (直近24h)",
            expires_in: 12.hours,
            func: -> {
              ::Swars::Battle.where(::Swars::Battle.arel_table[:created_at].gteq(24.hours.ago)).count
            },
          },

          ################################################################################

          {
            name: "Deadlocked (直近24h)",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "Deadlocked" }),
            func: -> { AppLog.subject_like("Deadlocked").where(AppLog.arel_table[:created_at].gteq(24.hours.ago)).count },
          },

          {
            name: "符号の鬼 (直近24h)",
            href: UrlProxy.full_url_for(path: "/xy".dasherize),
            func: -> { XyMaster::TimeRecord.where(XyMaster::TimeRecord.arel_table[:created_at].gteq(24.hours.ago)).count },
          },
        ]
      end
    end
  end
end

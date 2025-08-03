# http://localhost:4000/lab/admin/dashboard

module QuickScript
  module Admin
    class DashboardScript
      class DashboardItemInfo
        include ApplicationMemoryRecord
        memory_record [
          ################################################################################

          {
            name: "[共有] 接続数 (現在)",
            href: UrlProxy.full_url_for("/lab/admin/action_cable_info_script".dasherize),
            func: -> { ActionCable.server.open_connections_statistics.count },
          },
          {
            name: "[共有] 利用状況 (直近1h)",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "共有将棋盤" }),
            func: -> { AppLog.subject_like("共有将棋盤").where(created_at: 1.hours.ago..).count },
          },

          ################################################################################

          {
            name: "[共有] 対局部屋数",
            href: UrlProxy.full_url_for("/lab/admin/share_board_room_index".dasherize),
            func: -> { ShareBoard::Battle.where(created_at: 24.hours.ago..).select(:room_id).distinct.count },
          },
          {
            name: "[共有] 対局数",
            href: UrlProxy.full_url_for("/lab/admin/share_board_battle_index".dasherize),
            func: -> { ShareBoard::Battle.where(created_at: 24.hours.ago..).count },
          },

          ################################################################################

          {
            name: "[共有] 発言部屋数",
            href: UrlProxy.full_url_for(path: "/lab/admin/share_board_chat_message_index".dasherize),
            func: -> { ShareBoard::ChatMessage.where(created_at: 24.hours.ago..).select(:room_id).distinct.count },
          },
          {
            name: "[共有] 発言者数",
            href: UrlProxy.full_url_for(path: "/lab/admin/share_board_chat_message_index".dasherize),
            func: -> { ShareBoard::ChatMessage.where(created_at: 24.hours.ago..).select(:user_id).distinct.count },
          },
          {
            name: "[共有] 発言数",
            href: UrlProxy.full_url_for(path: "/lab/admin/share_board_chat_message_index".dasherize),
            func: -> { ShareBoard::ChatMessage.where(created_at: 24.hours.ago..).count },
          },
          {
            name: "[共有] 思考印",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "思考印" }),
            func: -> { AppLog.subject_like("思考印").where(created_at: 24.hours.ago..).count },
          },

          ################################################################################

          {
            name: "[ウ検] 検索数 (直近1h)",
            func: -> { ::Swars::SearchLog.where(created_at: 1.hours.ago..).count },
          },
          {
            name: "[ウ検] 検索数",
            func: -> { ::Swars::SearchLog.where(created_at: 24.hours.ago..).count },
          },
          {
            name: "[ウ検] 取込対局数",
            cache_expires_in: 12.hours,
            func: -> { ::Swars::Battle.where(created_at: 24.hours.ago..).count },
          },
          {
            name: "[ウ検] ID記憶案内 やってみる",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "ウォーズID記憶案内 やってみる" }),
            func: -> { AppLog.plus_minus_search("ウォーズID記憶案内 やってみる").where(created_at: 24.hours.ago..).count },
          },
          {
            name: "[ウ検] ID記憶案内 絶対やらない",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "ウォーズID記憶案内 絶対やらない" }),
            func: -> { AppLog.plus_minus_search("ウォーズID記憶案内 絶対やらない").where(created_at: 24.hours.ago..).count },
          },

          ################################################################################

          {
            name: "[例外] Deadlocked",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "Deadlocked" }),
            func: -> { AppLog.subject_like("Deadlocked").where(created_at: 24.hours.ago..).count },
          },
          {
            name: "[例外] RecordNotUnique",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "RecordNotUnique" }),
            func: -> { AppLog.subject_like("RecordNotUnique").where(created_at: 24.hours.ago..).count },
          },

          ################################################################################

          {
            name: "[符号の鬼] 挑戦者数",
            href: UrlProxy.full_url_for(path: "/xy".dasherize),
            func: -> { XyMaster::TimeRecord.where(created_at: 24.hours.ago..).select(:user_id).distinct.count },
          },
          {
            name: "[符号の鬼] 記録数",
            href: UrlProxy.full_url_for(path: "/xy".dasherize),
            func: -> { XyMaster::TimeRecord.where(created_at: 24.hours.ago..).count },
          },

          ################################################################################

          {
            name: "[将ドリ] 問題作成者数",
            href: UrlProxy.full_url_for(path: "/admin/script/wkbk_dashboard".dasherize),
            func: -> { Wkbk::Article.where(created_at: 24.hours.ago..).select(:user_id).distinct.count },
          },
          {
            name: "[将ドリ] 問題作成数",
            href: UrlProxy.full_url_for(path: "/admin/script/wkbk_dashboard".dasherize),
            func: -> { Wkbk::Article.where(created_at: 24.hours.ago..).count },
          },
          {
            name: "[将ドリ] 解いた人数",
            href: UrlProxy.full_url_for(path: "/admin/script/wkbk_dashboard".dasherize),
            func: -> { Wkbk::AnswerLog.where(created_at: 24.hours.ago..).select(:user_id).distinct.count },
          },
          {
            name: "[将ドリ] 解いた数",
            href: UrlProxy.full_url_for(path: "/admin/script/wkbk_dashboard".dasherize),
            func: -> { Wkbk::AnswerLog.where(created_at: 24.hours.ago..).count },
          },

          ################################################################################

          {
            name: "[KENTO] API",
            href: UrlProxy.full_url_for(path: "/lab/admin/app_log_search".dasherize, query: { query: "KENTO API" }),
            func: -> { AppLog.subject_like("KENTO API").where(created_at: 24.hours.ago..).count },
          },

          {
            name: "[Sidekiq] 死亡ジョブ数",
            href: UrlProxy.full_url_for(path: "/admin/sidekiq/morgue"),
            func: -> { Sidekiq::DeadSet.new.size },
          },

          {
            name: "[System] 負荷",
            func: -> { `uptime` },
          },

          ################################################################################

        ]

        def cache_key
          @cache_key ||= [self.class.name, key].join("/")
        end

        def name
          str = super
          if cache_expires_in
            str = "*#{str}"
          end
          str
        end

        def result
          if cache_expires_in
            Rails.cache.fetch(cache_key, expires_in: cache_expires_in) do
              func.call
            end
          else
            func.call
          end
        end
      end
    end
  end
end

module Swars
  class ZipDlScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :zdsk_inherit,
        name: proc {
          "そのまま"
        },
        message: proc {
          "一覧で表示した通りに上から順に最大#{zip_dl_max}件を取得します"
        },
        scope: proc {
          s = current_index_scope
          s = sort_scope(s)
          s = s.limit(zip_dl_max)
        },
      },

      {
        key: :zdsk_today,
        name: proc {
          "本日"
        },
        message: proc {
          "本日分に絞って日時昇順で最大#{zip_dl_max}件取得します"
        },
        scope: proc {
          s = current_index_scope
          t = Time.current.midnight
          s = s.where(battled_at: t...t.tomorrow)
          s = s.order(battled_at: :asc)
          s = s.limit(zip_dl_max)
        },
      },

      {
        key: :zdsk_continue,
        name: proc {
          "前回の続きから"
        },
        message: proc {
          if current_user
            if continue_begin_at
              time = continue_begin_at.to_s(:battle_time)
              "#{time} 以降を日時昇順で最大#{zip_dl_max}件取得します"
            else
              "「前回の続きから」以外の方法で一度ダウンロードすると使えるようになります"
            end
          else
            "ログインすると使えるようになります"
          end
        },
        scope: proc {
          s = current_index_scope
          if v = continue_begin_at
            s = s.where(Battle.arel_table[:battled_at].gteq(v))
            s = s.order(battled_at: :asc)
            s = s.limit(zip_dl_max)
          else
            s = s.none
          end
        },
      },
    ]
  end
end

module Swars
  module ZipDl
    class ScopeInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          key: :zdsk_continue,
          name: "前回の続きから",
          message: -> context {
            if context.current_user
              if context.continue_begin_at
                time = context.continue_begin_at.to_s(:battle_medium)
                # "#{time} 以降を日時昇順で最大#{zip_dl_max}件取得する (推奨)"
                "#{time} 以降を日時昇順で取得する (推奨)"
              else
                "「前回の続きから」以外の方法で一度ダウンロードすると使えるようになります"
              end
            else
              "ログインすると使えるようになります"
            end
          },
          scope: -> context {
            s = context.current_index_scope
            if v = context.continue_begin_at
              s = s.where(Battle.arel_table[:battled_at].gteq(v))
              s = s.reorder(battled_at: :asc)
              s = s.limit(context.zip_dl_max)
            else
              s = s.none
            end
          },
        },

        {
          key: :zdsk_today,
          name: "本日",
          message: -> context {
            # "本日分に絞って日時昇順で最大#{zip_dl_max}件取得する"
            "本日分を日時昇順で取得する"
          },
          scope: -> context {
            s = context.current_index_scope
            t = Time.current.midnight
            s = s.where(battled_at: t...t.tomorrow)
            s = s.reorder(battled_at: :asc)
            s = s.limit(context.zip_dl_max)
          },
        },

        {
          key: :zdsk_inherit,
          name: "そのまま",
          message: -> context {
            # "一覧で表示した通りに画面の上から順に最大#{zip_dl_max}件を取得する"
            "一覧で表示した通りに画面の上から順に取得する"
          },
          scope: -> context {
            s = context.current_index_scope
            # s = sort_scope(s)
            s = s.limit(context.zip_dl_max)
          },
        },
      ]
    end
  end
end

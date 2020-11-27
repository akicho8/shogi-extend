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
          "一覧で表示した通りに上から最大#{zip_dl_max}件を取得します"
        },
        scope: proc {
          s = current_index_scope
          s = sort_scope(s)
          s = s.limit(zip_dl_max)
        },
      },

      # {
      #   key: :zdsk_latest,
      #   name: proc {
      #     "直近"
      #   },
      #   scope: proc {
      #     s = current_index_scope
      #     s = s.order(battled_at: :desc)
      #     s = s.limit(zip_dl_max)
      #   },
      # },
      #

      {
        key: :zdsk_today,
        name: proc {
          "本日"
        },
        message: proc {
          "さらに本日分に絞ります"
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
              "さらに " + continue_begin_at.to_s(:battle_time) + " 以降を対象にします"
            else
              "前回がいつなのかわかってないので「前回の続きから」以外の方法で一度ダウンロードしてください"
            end
          else
            "この機能を使うにはログインが必要です"
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

      # {
      #   key: :zdsk_oldest,
      #   name: proc {
      #     "一番古い1件"
      #   },
      #   scope: proc {
      #     s = current_index_scope
      #     s = s.order(battled_at: :asc)
      #     s = s.limit(1)
      #   },
      # },

    ]
  end
end

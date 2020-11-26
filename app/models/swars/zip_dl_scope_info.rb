module Swars
  class ZipDlScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :today,
        name: proc {
          "本日分"
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
        key: :latest,
        name: proc {
          "直近"
        },
        scope: proc {
          s = current_index_scope
          s = s.order(battled_at: :desc)
          s = s.limit(zip_dl_max)
        },
      },

      {
        key: :continue,
        name: proc {
          "前回の続きから"
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
      #   key: :oldest,
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

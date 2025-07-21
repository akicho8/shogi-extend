class QuickScript::Swars::BattleDownloadScript
  class ScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :continue,
        name: "前回の続きから",
        el_message: "新しい棋譜だけを取得する(推奨) ※初回は直近を取得する",
        error_message: "前回取得以降の新しい対局がありません",
        scope: -> context, s {
          context.swars_user or raise "required context.swars_user"
          at = context.current_user.swars_zip_dl_logs.where(swars_user: context.swars_user).continue_begin_at
          if at
            s = s.where(::Swars::Battle.arel_table[:battled_at].gteq(at))
            s = s.reorder(battled_at: :asc)
          else
            s = s.reorder(battled_at: :desc) # 初回
          end
          s
        },
      },
      {
        key: :today,
        name: "本日",
        el_message: "本日分を日時昇順で取得する",
        error_message: "本日対局していないようです",
        scope: -> context, s {
          t = Time.current.beginning_of_day
          s = s.where(battled_at: t...t.tomorrow)
          s = s.reorder(battled_at: :asc)
        },
      },
      {
        key: :recent,
        name: "直近",
        error_message: "直近の対局がないようです (このメッセージはどこにも表示されないはず)",
        el_message: "対局日時が新しい順に取得する",
        scope: -> context, s {
          s = s.reorder(battled_at: :desc)
        },
      },
    ]
  end
end

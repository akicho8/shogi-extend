class QuickScript::Swars::GradeHistogramScript
  class ScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :normal,
        name: "全員",
        scope: -> scope { scope },
        el_message: "分別しない",
      },
      {
        key: :ban_only,
        name: "囚人のみ",
        scope: -> scope { scope.where(user: ::Swars::User.ban_only) },
        el_message: "垢BANされた人だけを対象とする",
      },
      {
        key: :ban_except,
        name: "囚人除外",
        el_message: "垢BANされた人は除外する",
        scope: -> scope { scope.where(user: ::Swars::User.ban_except) }
      },
    ]
  end
end

class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     wb_mark: "○" },
    { key: :lose, name: "負け",     wb_mark: "●" },
    { key: :draw, name: "引き分け", wb_mark: "─" },
  ]

  def swars_memberships
    Swars::Membership.where(judge_key: key)
  end
end

class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: :win,  name: "勝ち",     },
    {key: :lose, name: "負け",     },
    {key: :draw, name: "引き分け", },
  ]

  def swars_memberships
    Swars::Membership.where(judge_key: key)
  end

  def general_pmemberships
    General::Membership.where(judge_key: key)
  end
end

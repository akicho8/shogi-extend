class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     icon_args: [:crown],                 :icon_class => :icon_o,      },
    { key: :lose, name: "負け",     icon_args: ["emoticon-sad-outline"], :icon_class => :icon_x,      },
    { key: :draw, name: "引き分け", icon_args: [:minus],                 :icon_class => :icon_hidden, },
  ]

  def swars_memberships
    Swars::Membership.where(judge_key: key)
  end

  def general_memberships
    General::Membership.where(judge_key: key)
  end
end

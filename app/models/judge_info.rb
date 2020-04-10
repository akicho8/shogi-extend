class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     ox_mark: "○" },
    { key: :lose, name: "負け",     ox_mark: "●" },
    { key: :draw, name: "引き分け", ox_mark: "─" },
  ]

  def swars_memberships
    Swars::Membership.where(judge_key: key)
  end

  def flip
    if key == :draw
      return self
    end

    self.class.fetch(key == :win ? :lose : :win)
  end
end

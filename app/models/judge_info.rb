class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     ox_mark: "○", css_class: "has-text-weight-bold",   },
    { key: :lose, name: "負け",     ox_mark: "●", css_class: "has-text-weight-normal", },
    { key: :draw, name: "引き分け", ox_mark: "─", css_class: "has-text-weight-normal", },
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

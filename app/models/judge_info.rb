class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     ox_mark: "○", one_char: "勝", css_class: "has-text-weight-bold",   },
    { key: :lose, name: "負け",     ox_mark: "●", one_char: "負", css_class: "has-text-weight-normal", },
    { key: :draw, name: "引き分け", ox_mark: "─", one_char: "△", css_class: "has-text-weight-normal", },
  ]

  class << self
    def lookup(v)
      if v.respond_to?(:downcase)
        v = v.downcase
      end
      super || invert_table[v]
    end

    private

    def invert_table
      @invert_table ||= inject({}) {|a, e| a.merge(e.name => e, e.ox_mark => e, e.one_char => e) }
    end
  end

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

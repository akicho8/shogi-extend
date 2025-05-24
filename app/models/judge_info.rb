class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     ox_mark: "○", one_char: "勝", css_class: "has-text-weight-bold",   },
    { key: :lose, name: "負け",     ox_mark: "●", one_char: "負", css_class: "has-text-weight-normal", },
    { key: :draw, name: "引き分け", ox_mark: "─", one_char: "△", css_class: "has-text-weight-normal", },
  ]

  prepend AliasMod

  class << self
    def zero_default_hash
      @zero_default_hash ||= each_with_object({}) { |e, m|
        m[e.key] = 0
      }.freeze
    end

    def zero_default_hash_wrap(hash)
      zero_default_hash.merge(hash.symbolize_keys)
    end
  end

  class << self
    def key_cast(key)
      if key.respond_to?(:downcase)
        key = key.downcase
      end
      key
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

  def secondary_key
    [name, ox_mark, one_char]
  end
end

class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち",     short_name: "勝ち", ox_mark: "○", one_char: "勝", css_class: "has-text-weight-bold",   flip_key: :lose, },
    { key: :lose, name: "負け",     short_name: "負け", ox_mark: "●", one_char: "負", css_class: "has-text-weight-normal", flip_key: :win,  },
    { key: :draw, name: "引き分け", short_name: "引分", ox_mark: "─", one_char: "△", css_class: "has-text-weight-normal", flip_key: nil,   },
  ]

  prepend AliasMod

  class << self
    def key_cast(key)
      if key.respond_to?(:downcase)
        key = key.downcase
      end
      key
    end

    def zero_default_hash
      @zero_default_hash ||= each_with_object({}) { |e, m|
        m[e.key] = 0
      }.freeze
    end

    def zero_default_hash_wrap(hash)
      zero_default_hash.merge(hash.symbolize_keys)
    end
  end

  def swars_memberships
    Swars::Membership.where(judge_key: key)
  end

  def flip
    if flip_key
      self.class.fetch(flip_key)
    else
      self
    end
  end

  def secondary_key
    [name, ox_mark, one_char]
  end
end

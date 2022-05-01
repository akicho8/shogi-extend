module Swars
  concern :JudgeMethods do
    included do
      belongs_to :judge
      scope :judge_eq,     -> v { where(    judge_key: JudgeInfo.keys_from(v)) }
      scope :judge_not_eq, -> v { where.not(judge_key: JudgeInfo.keys_from(v)) }
      scope :judge_ex, proc  { |v; s, g|
        s = all
        g = xquery_parse(v)
        if g[true]
          s = s.judge_eq(g[true])
        end
        if g[false]
          s = s.judge_not_eq(g[false])
        end
        s
      }

      with_options presence: true do
        validates :judge_key
      end

      with_options allow_blank: true do
        validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
      end
    end

    def judge_key=(v)
      super
      self.judge = Judge.lookup(v)
    end

    def judge_info
      JudgeInfo[judge_key]
    end
  end
end

# frozen-string-literal: true

module Assertion
  extend self

  def assert_tag(tag)
    if Rails.env.local?
      assert_symbol(tag)
      unless Bioshogi::Explain::TacticInfo.flat_lookup(tag)
        raise ArgumentError, "存在しない : #{tag.inspect}"
      end
    end
  end

  def assert_judge_key(judge_key)
    if Rails.env.local?
      assert_symbol(judge_key)
      JudgeInfo.fetch(judge_key)
    end
  end

  def assert_final_key(final_key)
    if Rails.env.local?
      assert_symbol(final_key)
      Swars::FinalInfo.fetch(final_key)
    end
  end

  def assert_symbol(var)
    if Rails.env.local?
      unless var.kind_of? Symbol
        raise TypeError, "var はシンボルにすること : #{var.inspect}"
      end
    end
  end
end

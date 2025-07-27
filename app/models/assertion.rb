# frozen-string-literal: true

module Assertion
  extend self

  def assert_tag(tag)
    if Rails.env.local?
      assert_symbol(tag)
      unless Bioshogi::Analysis::TagIndex.lookup(tag)
        if false
          raise ArgumentError, "存在しない : #{tag.inspect}"
        else
          AppLog.debug("存在しない : #{tag.inspect}")
        end
      end
    end
  end

  def assert_imode_key(imode_key)
    if Rails.env.local?
      assert_symbol(imode_key)
      Swars::ImodeInfo.fetch(imode_key)
    end
  end

  def assert_xmode_key(xmode_key)
    if Rails.env.local?
      assert_symbol(xmode_key)
      Swars::XmodeInfo.fetch(xmode_key)
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
    assert_kind_of(var, Symbol)
  end

  def assert_string(var)
    assert_kind_of(var, String)
  end

  def assert_array(var)
    assert_kind_of(var, Array)
  end

  def assert_kind_of(var, klass)
    if Rails.env.local?
      unless var.kind_of? klass
        raise TypeError, "var は #{klass} にすること : #{var.inspect}"
      end
    end
  end
end

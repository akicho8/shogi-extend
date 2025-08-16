require "active_support/benchmark"

module TimeTrial
  extend self

  def ms(&block)
    ActiveSupport::Benchmark.realtime(:float_millisecond, &block)
  end

  def second(&block)
    ActiveSupport::Benchmark.realtime(:float_second, &block)
  end
end

module Benchmarker
  extend self

  def call(subject = nil, &block)
    res = nil
    time = Benchmark.realtime { res = yield }
    time = ActiveSupport::Duration.build(time).inspect
    AppLog.important(subject: "#{subject} #{time}".squish)
    res
  end
end

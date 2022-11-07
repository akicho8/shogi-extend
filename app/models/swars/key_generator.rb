module Swars
  module KeyGenerator
    extend self

    def generate(seed: 0)
      base = "2000-01-01".to_time
      time = base.advance(seconds: seed)
      str = time.strftime("%Y%m%d_%H%M%S")
      key = [:alice, :bob, str].join("-")
      KeyVo.wrap(key)
    end
  end
end

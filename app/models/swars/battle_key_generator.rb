module Swars
  class BattleKeyGenerator
    def initialize(seed: 0)
      @seed = seed
    end

    def generate
      base = "2000-01-01".to_time
      time = base.advance(seconds: @seed)
      str = time.strftime("%Y%m%d_%H%M%S")
      key = [:alice, :bob, str].join("-")
      BattleKey.create(key)
    end
  end
end

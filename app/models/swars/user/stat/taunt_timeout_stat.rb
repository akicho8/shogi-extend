# frozen-string-literal: true

module Swars
  module User::Stat
    class TauntTimeoutStat < TauntMateStat
      class << self
        def final_key
          :TIMEOUT
        end
      end
    end
  end
end

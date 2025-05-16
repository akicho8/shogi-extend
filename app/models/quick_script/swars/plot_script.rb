module QuickScript
  module Swars
    class PlotScript < Base
      self.title = "グラフまとめ"
      self.description = ""

      def call
        h_stack [
          %(<iframe width="480"  height="800" frameborder="0" src="/insight/swars/hourly_active_user_count.html"></iframe>),
          %(<iframe width="480"  height="800" frameborder="0" src="/insight/swars/hourly_active_user_strength.html"></iframe>),
          %(<iframe width="1600" height="800" frameborder="0" src="/insight/swars/tactic_stat.html"></iframe>),
        ]
      end
    end
  end
end

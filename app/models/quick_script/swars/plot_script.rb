module QuickScript
  module Swars
    class PlotScript < Base
      self.title = "グラフまとめ"
      self.description = ""

      def call
        h_stack [
          %(<iframe width="480"  height="800" frameborder="0" src="/lab/swars/hourly-active-user-count.html"></iframe>),
          %(<iframe width="480"  height="800" frameborder="0" src="/lab/swars/hourly-active-user-strength.html"></iframe>),
          %(<iframe width="1600" height="800" frameborder="0" src="/lab/swars/tactic-stat.html"></iframe>),
          %(<iframe width="800"  height="800" frameborder="0" src="/lab/swars/turn-average.html"></iframe>),
          %(<iframe width="800"  height="800" frameborder="0" src="/lab/swars/lose-pattern.html"></iframe>),
        ]
      end
    end
  end
end

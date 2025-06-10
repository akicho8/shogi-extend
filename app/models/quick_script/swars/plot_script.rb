module QuickScript
  module Swars
    class PlotScript < Base
      self.title = "グラフまとめ"
      self.description = ""

      def call
        elems = parts.collect do |e|
          path = "/lab/swars/#{e}.html"
          [
            %(<a href="#{path}" class="has-text-weight-bold">固定リンク</a>),
            %(<iframe width="800" height="600" frameborder="0" src="#{path}"></iframe>),
          ].join("<br>")
        end

        h_stack elems, style: "justify-content: center"
      end

      def parts
        [
          "hourly-active-user",
          "tactic-stat",
          "tactic-cross",
          "turn-average",
          "lose-pattern",
        ]
      end
    end
  end
end

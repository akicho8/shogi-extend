module QuickScript
  module Swars
    class PlotScript < Base
      self.title = "グラフまとめ"
      self.description = "あちこちにあるグラフへのリンク集"

      def call
        elems = parts.collect do |e|
          path = "/lab/#{e.dasherize}.html"
          [
            %(<a href="#{path}" class="has-text-weight-bold">開く</a>),
            %(<iframe width="800" height="600" frameborder="0" src="#{path}"></iframe>),
          ].join("<br>")
        end

        h_stack elems, style: "justify-content: center"
      end

      def parts
        [
          "swars/hourly_active_user",
          "swars/tactic_stat",
          "swars/tactic_cross",
          "swars/turn_average",
          "swars/lose_pattern",
          # "general/pre_professional_league",
        ]
      end
    end
  end
end

# http://localhost:4000/lab/dev/layout_level

module QuickScript
  module Dev
    class LayoutLevelScript < Base
      self.title = "level を並べる例"
      self.description = "たくさんあっても折り返ししないようだ"

      def call
        # https://bulma.io/documentation/layout/level/
        tag.div(:class => "level") do
          16.times.collect { |item|
            tag.div(:class => "level-item has-text-centered") do
              tag.div do
                [
                  tag.p("headers", :class => "headers"),
                  tag.p("title", :class => "title"),
                ].join.html_safe
              end
            end
          }.join.html_safe
        end
      end
    end
  end
end

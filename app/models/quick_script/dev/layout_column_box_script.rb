# http://localhost:4000/lab/dev/layout_column_box

module QuickScript
  module Dev
    class LayoutColumnBoxScript < Base
      self.title = "box を並べる例"
      self.description = ""

      def call
        tag.div(:class => "columns is-mobile is-multiline") do
          64.times.collect { |item|
            tag.div(:class => "column is-2") do
              tag.div(:class => "box has-text-centered") do
                name = tag.div(item, :class => "is-size-7")
                body = tag.div(item, :class => "has-text-weight-bold is-size-3")
                [name, body].join.html_safe
              end
            end
          }.join.html_safe
        end
      end
    end
  end
end

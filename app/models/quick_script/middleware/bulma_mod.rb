module QuickScript
  module Middleware
    concern :BulmaMod do
      # https://bulma.io/documentation/components/message/
      def bulma_messsage(subject: nil, body: nil, type: "is-warning")
        if body.kind_of?(Array)
          body = body.compact.join("<br/>").html_safe
        end

        tag.article(:class => "message #{type}") do
          out = []
          if subject
            out << tag.div(:class => "message-header") { subject }
          end
          if body
            out << tag.div(:class => "message-body") { body }
          end
          out.join.html_safe
        end
      end
    end
  end
end

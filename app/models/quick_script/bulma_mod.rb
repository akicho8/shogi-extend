module QuickScript
  concern :BulmaMod do
    def bulma_messsage(subject, body)
      return tag.article(:class => "message is-warning") do
        tag.div(subject, :class => "message-header") + tag.div(:class => "message-body") do
          body
        end
      end
    end
  end
end

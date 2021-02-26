# json のリンクをつけたいとき個別に include する
module AtomicScript
  concern :AddJsonLinkMethods do
    def response_render(*)
      out = super
      out << h.tag.div(:class => "buttons are-small") { h.link_to("json", params.merge(format: :json), :class => "button") }
      out
    end
  end
end

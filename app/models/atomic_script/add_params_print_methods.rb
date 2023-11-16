# params の内容を表示する
module AtomicScript
  concern :AddParamsPrintMethods do
    if Rails.env.local?
      def response_render(*)
        out = super
        out << h.tag.div(:class => "box") { params.to_html(:title => "params") }
        out
      end
    end
  end
end

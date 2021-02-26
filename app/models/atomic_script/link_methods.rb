module AtomicScript
  concern :LinkMethods do
    # include Rails.application.routes.url_helpers

    included do

      # URLを生成するときのプレフィクス
      class_attribute :url_prefix
      self.url_prefix = []

      delegate :script_link_path, :to => "self.class"
    end

    class_methods do
      def script_link_path(params = {})
        [*url_prefix, {:id => key}.merge(params)]
      end
    end

    # 自分のページにリンクするには？
    #   script_link_to("確認", :foo => 1)
    #
    # 別のスクリプトにリンクするには？
    #   script_link_to("確認", :id => "abc", :foo => 1)
    #
    def script_link_to(name, params, html_options = {})
      h.link_to(name, script_link_path(params), html_options)
    end
  end
end

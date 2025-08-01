module QuickScript
  module Middleware
    concern :HelperMod do
      def tag(...)
        @tag ||= h.tag(...)
      end

      def h
        @h ||= ApplicationController.helpers
      end

      # { _nuxt_link: "#{e.name}", _v_bind: { to: qs_nuxt_link_to(params: {foo: "bar"}) }, :class => "button is-light" }
      def qs_nuxt_link_to(options = {})
        options = {
          :qs_group_key => self.class.qs_group_key,
          :qs_page_key  => self.class.qs_page_key,
          :params       => {},
        }.merge(options)

        {
          :name => "lab-qs_group_key-qs_page_key",
          :params => {
            :qs_group_key => options[:qs_group_key],
            :qs_page_key => options[:qs_page_key].dasherize,
          },
          :query => options[:params],
        }
      end
    end
  end
end

module QuickScript
  module Middleware
    concern :HeaderLinkMod do
      def as_json(*)
        super.merge({
            :header_link_items => header_link_items,
          })
      end

      # Example:
      #
      #   def header_link_items
      #     super + [
      #       { type: "t_nuxt_link", name: "(t_nuxt_link)", _v_bind: { tag: "nuxt-link", to: { name: "lab-qs_group_key-qs_page_key", params: { qs_group_key: "dev", qs_page_key: "calc" }, query: { lhv: 100 } }, }, },
      #       { type: "t_link_to",   name: "(t_link_to)",   _v_bind: { href: "/lab/dev/calc?lhv=100", target: "_blank", }, },
      #     ]
      #   end
      def header_link_items
        []
      end
    end
  end
end

module QuickScript
  module Dev
    class HeaderLinkScript < Base
      self.title = "ヘッダーリンク"
      self.description = "ヘッダーにリンクを追加する"

      def header_link_items
        super + [
          { type: "t_nuxt_link", name: "(t_nuxt_link)", params: { to: { name: "lab-qs_group_key-qs_page_key", params: { qs_group_key: "dev", qs_page_key: "calc" }, query: { lhv: 100 } }, }, },
          { type: "t_link_to",   name: "(t_link_to)",   params: { href: "/lab/dev/calc?lhv=100", target: "_blank", }, },
        ]
      end
    end
  end
end

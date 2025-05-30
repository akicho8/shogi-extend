module QuickScript
  module Dev
    class HeaderLinkScript < Base
      self.title = "ヘッダーリンク"
      self.description = "ヘッダーにリンクを追加する"

      def header_link_items
        super + [
          { name: "(t_nuxt_link)", _v_bind: { tag: "nuxt-link", to: { name: "lab-qs_group_key-qs_page_key", params: { qs_group_key: "dev", qs_page_key: "calc" }, query: { lhv: 100 } }, }, },
          { name: "(t_link_to)",   _v_bind: { href: "/lab/dev/calc?lhv=100", target: "_blank", }, },
        ]
      end
    end
  end
end

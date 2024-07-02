module QuickScript
  module Dev
    class TableScript < Base
      self.title = "テーブル表示"

      def call
        [
          { name: "自動リンク", "種類": "value_type_is_text_direct_url",    :value =>  "http://example.com/", },
          { name: "Aタグ",      "種類": "value_type_is_link_to",             :value =>  { _link_to:   { name: "(name)", url: "http://example.com/" }, }, },
          { name: "nuxt-link",  "種類": "value_type_is_nuxt_link",             :value =>  { _nuxt_link: { name: "(name)", to: {name: "bin-qs_group_key-qs_key", params: {qs_group_key: "dev", qs_key: "calc"}, query: {lhv: 100}}, }, }, },
          { name: "HTML",       "種類": "value_type_is_beginning_html_tag", :value =>  "<b>foo</b>", },
        ]
      end
    end
  end
end

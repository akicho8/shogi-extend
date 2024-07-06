module QuickScript
  module Dev
    class ValueScript < Base
      self.title = "値の表示"
      self.description = "すべての表示形式のテスト"

      def call
        [
          { name: "テキスト(そのまま)",     type: "value_type_is_text",         value: "URL は http://example.com/ です", },
          { name: "テキスト(v-text相当)",   type: "value_type_is_v_text",       value: { _v_text: "URL は http://example.com/ です" }, },
          { name: "テキスト(preで囲む)",    type: "value_type_is_pre",          value: { _pre: "URL は http://example.com/ です" }, },
          { name: "テキスト(自動リンク)",   type: "value_type_is_autolink",     value: { _autolink: "URL は http://example.com/ です" }, },
          { name: "HTML",                   type: "value_type_is_html",         value: "<b>foo</b>", },
          { name: "Aタグ",                  type: "value_type_is_link_to",      value: { _link_to:   { name: "(name)", url: "http://example.com/" }, }, },
          { name: "nuxt-link",              type: "value_type_is_nuxt_link",    value: { _nuxt_link: { name: "(name)", to: {name: "bin-qs_group_key-qs_page_key", params: {qs_group_key: "dev", qs_page_key: "calc"}, query: {lhv: 100}}, }, }, },
          { name: "数字",                   type: "value_type_is_unknown",      value: 1,   },
          { name: "nil",                    type: "value_type_is_unknown",      value: nil, },
          { name: "ハッシュ",               type: "value_type_is_any_hash",     value: { id: 1, name: "alice" }, },
          { name: "文字列配列",             type: "value_type_is_string_array", value: ["alice", "bob"], },
          { name: "テーブル",               type: "value_type_is_hash_array",   value: [{ id: 1, name: "alice" }], },
          { name: "コンポーネント指定",     type: "value_type_is_component",    value: { _component: "QuickScriptViewValueAsPre",  body: "(body)" }, },
          { name: "縦並び",                 type: "value_type_is_component",    value: { _component: "QuickScriptViewValueAsV", body: ["a", "b"] }, },
          { name: "横並び",                 type: "value_type_is_component",    value: { _component: "QuickScriptViewValueAsH", body: ["a", "b"] }, },
        ].collect do |e|
          {
            :name  => e[:name],
            :type  => e[:type],
            "表示" => e[:value],
            "表記" => { _v_text: e[:value].inspect },
          }
        end
      end
    end
  end
end

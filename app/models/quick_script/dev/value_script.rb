module QuickScript
  module Dev
    class ValueScript < Base
      self.title = "値の表示"
      self.description = "すべての表示形式のテスト"

      def call
        [
          { name: "テキスト(そのまま)",     type: "value_type_is_text",         value: "<b>foo</b>", },
          { name: "テキスト(v-text相当)",   type: "value_type_is_v_text",       value: { _v_text: "<b>foo</b>", style: "color: blue" }, },
          { name: "テキスト(v-html相当)",   type: "value_type_is_v_html",       value: { _v_html: "<b>foo</b>", :class => "box" }, },
          { name: "タグで始まる",           type: "value_type_is_html",         value: "<b>foo</b>", },
          { name: "テキスト(preで囲む)",    type: "value_type_is_pre",          value: { _pre: "<b>foo</b>" }, },
          { name: "テキスト(自動リンク)",   type: "value_type_is_autolink",     value: { _autolink: "URL は http://example.com/ です" }, },
          { name: "Aタグ",                  type: "value_type_is_link_to",      value: { _link_to:   { name: "(name)", url: "http://example.com/" }, }, },
          { name: "nuxt-link",              type: "value_type_is_nuxt_link",    value: { _nuxt_link: { name: "(name)", to: { name: "lab-qs_group_key-qs_page_key", params: { qs_group_key: "dev", qs_page_key: "calc" }, query: { lhv: 100 } }, }, }, },
          { name: "数字",                   type: "value_type_is_unknown",      value: 1,   },
          { name: "nil",                    type: "value_type_is_unknown",      value: nil, },
          { name: "ハッシュ",               type: "value_type_is_any_hash",     value: { id: 1, name: "alice" }, },
          { name: "文字列配列",             type: "value_type_is_string_array", value: ["alice", "bob"], },
          { name: "テーブル",               type: "value_type_is_hash_array",   value: [{ id: 1, name: "alice" }], },
          { name: ".box",                   type: "value_type_is_component",    value: { _component: "QuickScriptViewValueAsBox", _v_bind: { value: "(value)" } }, },
          { name: "コンポーネント指定",     type: "value_type_is_component",    value: { _component: "QuickScriptViewValueAsPre", _v_bind: { value: "(value)" } }, },
          { name: "横並び",                 type: "value_type_is_component",    value: { _component: "QuickScriptViewValueAsH",   _v_bind: { value: ["a", "b"], }, style: { "gap" => "1.0rem" } }, },
          { name: "縦並び",                 type: "value_type_is_component",    value: { _component: "QuickScriptViewValueAsV",   _v_bind: { value: ["a", "b"], }, style: { "gap" => "1.0rem" } }, },
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

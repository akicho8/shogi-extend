module QuickScript
  module Chore
    class LinkScript < Base
      self.title = "テーブル内リンクのテスト"

      def call
        [
          { name: "外部URL", url: "http://example.com/", },
          { name: "内部URL", url: { _nuxt_link: { name: "name 形式", to: {name: "script-sgroup-skey", params: {skey: "calc"}, query: {lhv: 100}}, }, }, },
          { name: "内部URL", url: { _nuxt_link: { name: "path 形式", to: {path: "/script/chore/calc?lhv=100"}, }, }, },
        ]
      end
    end
  end
end

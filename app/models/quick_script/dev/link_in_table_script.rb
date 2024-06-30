module QuickScript
  module Dev
    class LinkInTableScript < Base
      self.title = "テーブル内リンクのテスト"

      def call
        [
          { name: "外部URL", url: "http://example.com/", },
          { name: "内部URL", url: { _nuxt_link: { name: "name 形式", to: {name: "bin-sgroup-skey", params: {sgroup: "dev", skey: "calc"}, query: {lhv: 100}}, }, }, },
          { name: "内部URL", url: { _nuxt_link: { name: "path 形式", to: {path: "/bin/dev/calc?lhv=100"}, }, }, },
        ]
      end
    end
  end
end

module QuickScriptNs
  class LinkScript < Base
    def call
      [
        { name: "外部URL", url: "http://example.com/", },
        { name: "内部URL", url: { _nuxt_link: { name: "name 形式", to: {name: "script-id", params: {id: "calc"}, query: {lhv: 100}}, }, }, },
        { name: "内部URL", url: { _nuxt_link: { name: "path 形式", to: {path: "/script/calc?lhv=100"}, }, }, },
      ]
    end

    def meta
      super.merge({
          :title        => "テーブル内リンクのテスト",
          :description  => "",
        })
    end
  end
end

module QuickScriptNs
  class IndexScript < Base
    def call
      [
        { name: "a", url: "http://example.com/", },
      ]
    end

    def meta
      super.merge({
          :title        => "一覧",
          :description  => "",
        })
    end
  end
end

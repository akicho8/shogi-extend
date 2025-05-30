module QuickScript
  module Dev
    class StatusCodeTesterScript < Base
      self.title = "ステイタスコードのテスト"
      self.description = "CSR で 404, 500, 503 などをサーバーから返させる"

      def call
        [
          { "URL" => { _nuxt_link: "403", _v_bind: { to: { path: "/lab/chore/status_code", query: { status_code: 403, primary_error_message: nil, } }, }, },                       "説明" => "ログインしていないとき", },
          { "URL" => { _nuxt_link: "404", _v_bind: { to: { name: "/lab/chore/status_code", query: { status_code: 404, primary_error_message: nil, } }, }, },                       "説明" => "", },
          { "URL" => { _nuxt_link: "404", _v_bind: { to: { name: "/lab/chore/status_code", query: { status_code: 404, primary_error_message: "(primary_error_message)", } }, }, }, "説明" => "文言変更", },
          { "URL" => { _nuxt_link: "500", _v_bind: { to: { name: "/lab/chore/status_code", query: { status_code: 500, primary_error_message: nil,                       } }, }, }, "説明" => "", },
          { "URL" => { _nuxt_link: "503", _v_bind: { to: { name: "/lab/chore/status_code", query: { status_code: 503, primary_error_message: nil,                       } }, }, }, "説明" => "", },
        ]
      end
    end
  end
end

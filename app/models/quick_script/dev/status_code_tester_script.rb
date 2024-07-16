module QuickScript
  module Dev
    class StatusCodeTesterScript < Base
      self.title = "ステイタスコードのテスト"
      self.description = "CSR で 404, 500, 503 などをサーバーから返させる"

      def call
        [
          { "URL" => { _nuxt_link: { name: "403", to: { path: "/bin/chore/status_code", query: { status_code: 403, primary_error_message: nil, }}, }, },                       "説明" => "ログインしていないとき", },
          { "URL" => { _nuxt_link: { name: "404", to: { name: "/bin/chore/status_code", query: { status_code: 404, primary_error_message: nil, }}, }, },                       "説明" => "", },
          { "URL" => { _nuxt_link: { name: "404", to: { name: "/bin/chore/status_code", query: { status_code: 404, primary_error_message: "(primary_error_message)", }}, }, }, "説明" => "文言変更", },
          { "URL" => { _nuxt_link: { name: "500", to: { name: "/bin/chore/status_code", query: { status_code: 500, primary_error_message: nil,                       }}, }, }, "説明" => "", },
          { "URL" => { _nuxt_link: { name: "503", to: { name: "/bin/chore/status_code", query: { status_code: 503, primary_error_message: nil,                       }}, }, }, "説明" => "", },
        ]
      end
    end
  end
end

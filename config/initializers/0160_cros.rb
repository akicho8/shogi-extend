# gem 'rack-cors',require: 'rack/cors'
#
# ▼ ~/src/shogi_web/config/initializers/0160_cros.rb
#
# // Rails.application.config.middleware.insert_before 0, Rack::Cors do
# //   allow do
# //     origins '*'
# //     resource '*', headers: :any, methods: [:get, :post, :options]
# //   end
# // end
#
# if Rails.env.development? || Rails.env.staging?
#   Rails.application.config.middleware.insert_before 0, Rack::Cors do
#     allow do
#       # origins "*" とした場合、credentials: true にはできない
#       origins "localhost:8080", "localhost:8081", "web.kokokarago.wondertap.jp"
#       resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head], credentials: true
#     end
#   end
# end
#
# ▼これがいいかも
#
# if Rails.env.development? || Rails.env.staging?
#   Rails.application.config.middleware.insert_before 0, Rack::Cors do
#     allow do
#       # 異なるドメインでもクッキーを有効にするには origins を設定し credentials: true とする
#       origins "*"
#       resource '*', headers: :any, methods: :any
#     end
#   end
# end

# FIXME: これは何のために入れてある？？？

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # if Rails.env.production?
    #   origins ENV["MY_APP_HOST"] || "tk2-221-20341.vs.sakura.ne.jp"
    # else
    # end
    origins "*"
    resource "*", headers: :any, methods: [:head, :get, :options]
  end
end

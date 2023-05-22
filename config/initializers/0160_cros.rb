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
#       origins "localhost:8080", "localhost:8081"
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

# 外部から fetch("http://localhost:3000/w.json?query=DevUser1").then(r => r.json()).then(r => console.log(r)) できるかどうかで確認できる
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # if Rails.env.production? || Rails.env.staging?
    #   origins "www.shogi-extend.com"
    # else
    # end

    # origins "*"                 # クッキーが欲しいときはそのサーバーを明示的に指定する必要があり)

    if Rails.env.development?
      # origins "0.0.0.0:4000"
      # resource "*", headers: :any, methods: [:head, :get, :post, :patch, :put, :options], credentials: true
      origins *[
        # (ENV["DOMAIN"] || "localhost") + ":4000",
        "localhost:4000",
        "0.0.0.0:4000",
        "10.0.1.2:4000",        # スマホを 10.0.1.2:4000 で見ているとき、これを設定するとしゃべるようになる
        "10.0.1.16:4000",       # ikemac2023
      ]
      resource "*", {
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true,
      }
    else
      origins "*"
      resource "*", {
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
      }
    end
  end
end

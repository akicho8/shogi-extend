# if Rails.env.development? || Rails.env.test?
#   WebMock::API.stub_request(:any, %r{shogiwars.heroz.jp/users/history/}).to_return(body: Rails.root.join("config/https___shogiwars_heroz_jp_users_history_hanairobiyori_gtype_sb_locale_ja.html").read)
#   WebMock::API.stub_request(:any, %r{kif-pona.heroz.jp/games/}).to_return(body: Rails.root.join("config/http___kif_pona_heroz_jp_games_hanairobiyori_ispt_20171104_220810_locale_ja.html").read)
#
#   # 上記を有効にする (他は禁止)
#   WebMock.enable!
#
#   # 他を一旦許可して
#   WebMock.allow_net_connect!
#
#   # webpacker を除いて禁止する
#   WebMock.disable_net_connect!(allow_localhost: true)
# end
#
# 上の設定をすると次のエラーになる
#
# 16:39:20 web.1             | 2017-11-23 16:39:20 +0900: Rack app error handling request { GET /packs/application-ab607e8b68f2d2b7e915f146ec5ab731.css }
# 16:39:20 web.1             | #<NoMethodError: undefined method `closed?' for nil:NilClass>
# 16:39:20 web.1             | /usr/local/var/rbenv/versions/2.4.1/lib/ruby/2.4.0/net/http.rb:1484:in `begin_transport'
# 16:39:20 web.1             | /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/rack-proxy-0.6.2/lib/net_http_hacked.rb:50:in `begin_request_hacked'
# 16:39:20 web.1             | /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/rack-proxy-0.6.2/lib/rack/http_streaming_response.rb:60:in `response'
# 16:39:20 web.1             | /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/rack-proxy-0.6.2/lib/rack/http_streaming_response.rb:29:in `headers'
# 16:39:20 web.1             | /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/rack-proxy-0.6.2/lib/rack/proxy.rb:120:in `perform_request'
# 16:39:20 web.1             | /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/webpacker-3.0.2/lib/webpacker/dev_server_proxy.rb:15:in `perform_request'
#
# rack-proxy も net/http をいじっているため干渉しているようだ

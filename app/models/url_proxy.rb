# Rails側 x Nuxt側 x development x production のカオスな環境でのURLの差異を吸収するよくわからない機能
#
# 経緯
#
# まず routes.rb で次のように定義した
#
#   direct :about_terms do |options = {}|
#     if Rails.env.development?
#       "http://localhost:4000/about/terms"
#     else
#       "/about/terms"
#     end
#   end
#
# しかし link_to(..., :about_terms) とするとドメインの部分は省略され /about_terms/terms になってしまう
# だからといって about_terms_url と書くのは本番でもドメインが含まれてしまっていや
# なので独自に変換することにした
#
module UrlProxy
  extend self

  # ホストなし
  # rails r "p UrlProxy.url_for('/about/terms')"
  # rails r "p UrlProxy.url_for(path: '/swars/search', query: {query: 'devuser1'})"
  def url_for(*args)
    workaround(*args)
  end

  # ホストあり
  # メールとかに埋めるとき用としたい
  def full_url_for(*args)
    workaround(*args, long_url: true)
  end

  # 開発環境のときだけ Nuxt 側に切り替える
  def workaround(path, options = {})
    if path.kind_of?(Hash)
      if query = path[:query].presence
        if query.kind_of?(Hash)
          query = query.to_query
        end
      end

      if path[:path].blank?
        raise ArgumentError, "path[:path] is blank"
      end

      unless path[:path].start_with?("/")
        raise ArgumentError, "path が / から始まっていない : #{path[:path].inspect}"
      end

      path = [path[:path], query].compact.join("?")
    end

    if Rails.env.development? || Rails.env.test?
      domain = ENV["DOMAIN"] || "localhost"
      path = "http://#{domain}:4000" + path
    else
      if options[:long_url]
        path = host + path
      end
    end

    path
  end

  def host
    @host ||= Rails.application.routes.url_helpers.url_for(:root).chop
  end
end

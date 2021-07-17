# routes.rb で次のように定義した
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
# なので独自に変換する
module UrlProxy
  extend self

  # def [](*args)
  #   workaround(*args)
  # end

  # rails r "p UrlProxy.wrap('/about/terms')"
  # rails r "p UrlProxy.wrap(path: '/swars/search', query: {query: 'devuser1'})"
  def wrap(args)
    workaround(args)
  end

  def wrap2(args)
    workaround(args, long_url: true)
  end

  # 開発環境のときだけ Nuxt 側に切り替える
  def workaround(path, options = {})
    if path.kind_of?(Hash)
      if query = path[:query].presence
        if query.kind_of?(Hash)
          query = query.to_query
        end
      end

      path[:path] or raise "must not happen"

      unless path[:path].start_with?("/")
        raise "path が / から始まっていない : #{path[:path].inspect}"
      end

      path = [path[:path], query].compact.join("?")
    end

    if Rails.env.development? || Rails.env.test?
      domain = ENV["DOMAIN"] || "localhost"
      path = "http://#{domain}:4000" + path
    else
      if options[:long_url]
        path = Rails.application.routes.url_helpers.url_for(:root).chop + path
      end
    end

    path
  end
end

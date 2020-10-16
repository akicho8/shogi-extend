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

  def [](*args)
    workaround(*args)
  end

  # rails r "p UrlProxy.wrap('/about/terms')"
  # rails r "p UrlProxy.wrap(path: '/swars/search', query: {query: 'devuser1'})"
  def wrap(*args)
    workaround(*args)
  end

  def workaround(path)
    if path.kind_of?(Hash)
      if query = path[:query].presence
        if query.kind_of?(Hash)
          query = query.to_query
        end
      end
      path[:path] or raise "must not happen"
      path = [path[:path], query].compact.join("?")
    end

    if Rails.env.development? || Rails.env.test?
      domain = ENV["DOMAIN"] || "0.0.0.0"
      return "http://#{domain}:4000" + path
    end

    path
  end
end

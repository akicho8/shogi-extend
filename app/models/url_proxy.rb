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

  def wrap(*args)
    workaround(*args)
  end

  # rails r "p UrlProxy.workaround('/about/terms')"
  def workaround(path)
    if Rails.env.development? || Rails.env.test?
      domain = ENV["DOMAIN"] || "lvh.me"
      return "http://#{domain}:4000" + path
    end

    path
  end
end

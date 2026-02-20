# desc "サーバー起動確認"
# task :url_verifier do
#   run_locally do
#     UrlVerifier.call(fetch(:verification_urls))
#   end
# end
# after "deploy:finished", "url_verifier"

class UrlVerifier
  class << self
    def call(...)
      new(...).call
    end
  end

  def initialize(urls, options = {})
    @urls = urls
    @options = {
      :interval => 1.0,
      :count    => 5,
      :timeout  => 5.0,
    }.merge(options)
  end

  def call
    all_success = urls.all? { |url| verify_url(url) }
    tp([{"最終結果" => all_success ? "成功" : "失敗"}])
    unless all_success
      Say.call "デプロイ後の疎通確認に失敗しました"
    end
  end

  private

  def verify_url(url)
    @options[:count].times.any? do |i|
      report = {
        "日時"   => Time.now.strftime("%X %F"),
        "X回目"  => i.next,
        "結果"   => "",
        "URL"    => url,
      }
      if i > 0
        sleep(@options[:interval]**i)
      end
      begin
        response = Faraday.get(url) do |req|
          req.options.timeout = @options[:timeout]
        end
        tp [report.merge("結果" => response.status)]
        response.success?
      rescue Faraday::Error => e
        tp [report.merge("エラー" => e.class.name)]
        false
      end
    end
  end

  attr_reader :urls
end

class WebAgent
  DEFAULT_USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"

  class << self
    def document(url, params = {})
      new(params).document(url)
    end

    def fetch(url, params = {})
      new(params).fetch(url)
    end

    def raw_fetch(url, params = {})
      new(params).raw_fetch(url)
    end
  end

  def initialize(params = {})
    @params = {
      :user_agent => nil,
    }.merge(params)
  end

  # 結局欲しいのはこれ
  def document(url)
    Nokogiri::HTML(fetch(url))
  end

  # 次のタグかなんかが含まれていたら UTF-8 にする
  # <meta charset="Shift_JIS" />
  # <meta charset="EUC-JP" />
  def fetch(url)
    s = raw_fetch(url)
    if !s.match?(/UTF.?8/i) || s.match?(/Shift_JIS|EUC-JP/i)
      s = s.toutf8
    end
    s
  end

  def raw_fetch(url_or_uri)
    response = agent.get(url_or_uri.to_s)
    response.body
  end

  private

  def agent
    Faraday.new do |e|
      e.response :follow_redirects # リダイレクト先をおっかける
      e.headers[:user_agent] = @params[:user_agent] || DEFAULT_USER_AGENT
      # adapter は最後に書く
      # https://nekorails.hatenablog.com/entry/2018/09/28/152745
      e.adapter Faraday.default_adapter
    end
  end
end

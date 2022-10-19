# TinyUrl.from("https://example.com/") # => "https://tinyurl.com/yqp7ct"
# TinyUrl.from("xxx")                  # => "xxx"
module TinyUrl
  extend self

  def from(url)
    create(url) || url
  end

  def create(url)
    begin
      resp = Faraday.get("https://tinyurl.com/api-create.php", url: url)
      if !resp.success?
        raise "短縮URL化に失敗しました : #{url.inspect}"
      end
      resp.body
    rescue => error
      ExceptionNotifier.notify_exception(error)
      nil
    end
  end
end

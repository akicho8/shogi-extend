module TinyUrl
  extend self

  def create(url)
    begin
      resp = Faraday.get("https://tinyurl.com/api-create.php", url: url)
      if resp.success?
        resp.body
      end
    rescue => error
      ExceptionNotifier.notify_exception(error)
      nil
    end
  end

  def safe_create(url)
    create(url) || url
  end
end

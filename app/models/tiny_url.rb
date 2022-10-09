

# => "https://tinyurl.com/yqp7ct"

module TinyUrl
  extend self

  def create(url)
    begin
      resp = Faraday.get("https://tinyurl.com/api-create.php", url: url)
      if resp.success?
        resp.body
      end
    rescue => error
      SlackAgent.notify_exception(error)
      nil
    end
  end
end

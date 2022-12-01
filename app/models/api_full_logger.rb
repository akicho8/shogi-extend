class ApiFullLogger
  def initialize(context)
    @context = context
  end

  def perform
    if enabled?
      SlackAgent.notify(subject: "API", body: body, emoji: ":API:")
    end
  end

  private

  attr_reader :context
  delegate :request, to: :context

  def enabled?
    if Rails.env.development? || Rails.env.staging? || context.params["__API_LOG_FORCE__"]
      return true
    end
    if context.from_crawl_bot?
      return
    end
    if request.origin.to_s == AppConfig[:my_request_origin]
      return
    end
    if Rails.env.production?
      return
    end
    true
  end

  def body
    env = request.env.reject { |k, v| k.match?(/HTTP_(?:SEC_|ACCEPT_|COOKIE)/) }
    env.find_all { |k, v| k.to_s.match?(/^[A-Z]/) }.to_h.to_s
  end
end

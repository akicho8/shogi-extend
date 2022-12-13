class ApiFullLogger
  def initialize(context)
    @context = context
  end

  def perform
    if enabled?
      SlackAgent.notify(subject: subject, body: body, emoji: ":API:")
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
    true
  end

  def subject
    "#{request.request_method} #{context.controller_name}##{context.action_name}"
  end

  def body
    {
      :env        => env_hash,
      :from       => request.from,
      :origin     => request.origin,
      :user_agent => request.user_agent,
      :params     => context.params.to_unsafe_h.except(:action, :controller),
    }.compact
  end

  def env_hash
    env = request.env.reject { |k, v| k.match?(/HTTP_(?:SEC_|ACCEPT_|COOKIE)/) }
    env = env.find_all { |k, v| k.to_s.match?(/^[A-Z]/) }.to_h
  end
end

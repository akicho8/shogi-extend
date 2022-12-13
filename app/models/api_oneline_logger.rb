class ApiOnelineLogger
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
    [
      request.from || request.origin,
      context.params.to_unsafe_h.except(:action, :controller).inspect,
    ].compact.join(" ").truncate(100)
  end
end

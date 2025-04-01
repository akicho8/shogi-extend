class RequestInfo
  def initialize(controller)
    @controller = controller
  end

  def to_s
    o = []
    o << "* Access"
    o << "#{request.request_method} #{controller.controller_name}##{controller.action_name}"
    o << ""
    if v = request.env["exception_notifier.exception_data"]
      o << "* exception_notifier.exception_data"
      o << v.to_t
    end
    o << "* From"
    o << from_hash.to_t
    o << "* Params"
    o << params.to_unsafe_h.to_t
    o << "* Environment"
    o << env_hash.to_t
    o.collect { |e| e.toutf8 }.join("\n")
  end

  private

  attr_reader :controller
  delegate :request, :params, to: :controller

  def from_hash
    {
      :from       => request.from,
      :origin     => request.origin,
      :user_agent => request.user_agent,
    }
  end

  def env_hash
    hv = request.env
    hv = hv.reject { |k, v| k.match?(/HTTP_(?:ACCEPT_|COOKIE)/) }
    hv = hv.find_all { |k, v| k.to_s.match?(/^[A-Z]/) }.to_h
  end
end

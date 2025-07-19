class EvalController < ApplicationController
  skip_before_action :user_name_required

  before_action if: proc { Rails.env.production? || Rails.env.staging? } do
    raise ActionController::RoutingError, "No route matches [#{request.method}] #{request.path_info.inspect}"
  end

  # 必須
  skip_forgery_protection

  def run
    retval = evaluate(current_code)
    console_str = ">> #{current_code}\n#{retval}"

    if v = params[:redirect_to].presence
      redirect_to v, alert: h.simple_format(console_str)
      return
    end

    html = h.content_tag(:pre, console_str)
    render html: html, layout: true
  end

  private

  def current_code
    params[:code]
  end

  def evaluate(input)
    begin
      retval = eval(input)
      if !retval.kind_of?(String) && retval.respond_to?(:to_t)
        retval = retval.to_t
      end
      retval
    rescue => error
      backtrace = Array(error.backtrace) - caller
      ["#{error.class.name}: #{error}\n", *backtrace.map { |e| "#{' ' * 8}from #{e}\n" }].join
    end
  end
end

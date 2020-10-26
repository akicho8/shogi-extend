class EvalController < ApplicationController
  skip_before_action :user_name_required

  before_action if: proc { Rails.env.production? || Rails.env.staging? } do
    raise ActionController::RoutingError, "No route matches [#{request.method}] #{request.path_info.inspect}"
  end

  def run
    retv = evaluate(current_code)
    console_str = ">> #{current_code}\n#{retv}"

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
      retv = eval(input)
      if !retv.kind_of?(String) && retv.respond_to?(:to_t)
        retv = retv.to_t
      end
      retv
    rescue => error
      backtrace = Array(error.backtrace) - caller
      ["#{error.class.name}: #{error}\n", *backtrace.map { |e| "#{' ' * 8}from #{e}\n"}].join
    end
  end
end

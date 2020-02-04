module ShogiErrorRescueMod
  extend ActiveSupport::Concern

  included do
    rescue_from "Bioshogi::BioshogiError" do |error|
      if Rails.env.development?
        Rails.logger.info(error)
        sleep(0.5)
      end

      ErrorNotifier.notify_error(error, env: request.env, data: {params: params.to_unsafe_h})

      if request.format.json?
        render json: as_shogi_error_attrs(error)
      else
        behavior_after_rescue(error_html_build(error))
      end
    end
  end

  private

  def as_shogi_error_attrs(error)
    {
      bs_error: {
        message_prefix: message_prefix_build(error),
        message: error.message.lines.first.strip,
        board: error.message.lines.drop(1).join,
      },
    }
  end

  def message_prefix_build(e)
    s = []
    if e.respond_to?(:mediator)
      s << "#{e.mediator.turn_info.counter + 1}手目"
      s << "#{e.mediator.current_player.call_name}番"
    end
    if e.respond_to?(:input)
      s << "#{e.input.input.values.join}"
    end
    s = s.join.squish
    if s.present?
      "(#{s})"
    end
  end

  def error_html_build(e)
    h = ApplicationController.helpers
    lines = error.message.lines
    s = lines.first.strip.html_safe
    if field = lines.drop(1).presence
      s += h.tag.div(field.join.html_safe, :class => "error_message_pre").html_safe
    end
    if v = error.backtrace
      s += h.tag.div(v.first(8).join("\n").html_safe, :class => "error_message_pre").html_safe
    end
    s
  end
end

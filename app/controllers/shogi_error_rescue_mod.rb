module ShogiErrorRescueMod
  extend ActiveSupport::Concern

  included do
    if Rails.env.development?
      before_action do
        if params[:bioshogi_error1]
          raise Bioshogi::BioshogiError, "将棋関連のエラーのテスト"
        end
        if params[:bioshogi_error2]
          Bioshogi::Parser.parse("11玉").to_kif
        end
      end
    end

    rescue_from "Bioshogi::BioshogiError" do |error|
      if Rails.env.development?
        Rails.logger.info(error)
        Rails.logger.info(error.backtrace.join("\n"))
        sleep(0.5)
      end

      case
      when request.format.json?
        # なんでも棋譜変換の場合は頻繁にエラーになるためエラー通知しない
        render json: as_shogi_error_attrs(error)
      when request.format.png?
        ExceptionNotifier.notify_exception(error, env: request.env, data: {params: params.to_unsafe_h})

        # https://developer.mozilla.org/ja/docs/Web/HTTP/Status/422
        send_file Rails.root.join("app/assets/images/fallback.png"), type: Mime[:png], disposition: "inline", status: 422
      else
        # 野良棋譜投稿の場合は滅多に使われないので通知する
        #   EXCEPTION_NOTIFICATION_ENABLE=1 foreman s
        # で確認できる
        ExceptionNotifier.notify_exception(error, env: request.env, data: {params: params.to_unsafe_h})
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
      s << "#{e.mediator.turn_info.display_turn.next}手目"
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
    lines = e.message.lines
    s = lines.first.strip.html_safe
    if field = lines.drop(1).presence
      s += h.tag.div(field.join.html_safe, :class => "error_message_pre_with_margin").html_safe
    end
    if Rails.env.development?
      # ActionDispatch::Cookies::CookieOverflow になるので入れてはいけない
      # if v = e.backtrace
      #   s += h.tag.div(v.first(8).join("\n").html_safe, :class => "error_message_pre_with_margin").html_safe
      # end
    end
    s
  end
end

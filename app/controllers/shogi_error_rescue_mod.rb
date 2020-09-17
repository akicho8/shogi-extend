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
        Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, error])
        Rails.logger.info(error.backtrace.join("\n"))
        sleep(0.5)
      end

      slack_message(key: error.class.name, body: [error.message, params].join("\n"), channel: "#adapter_error")
      ExceptionNotifier.notify_exception(error, env: request.env, data: {params: params.to_unsafe_h})

      case
      when request.format.json?
        # なんでも棋譜変換の場合は頻繁にエラーになるため ExceptionNotifier しない
        render json: as_bs_error(error) # status: 500 としたいが production で json を HTML で上書きされてしまう
      when request.format.png?
        # https://developer.mozilla.org/ja/docs/Web/HTTP/Status/422
        send_file Rails.root.join("app/assets/images/fallback.png"), type: Mime[:png], disposition: "inline", status: 422
      # when request.format.html?
      #   # 野良棋譜投稿の場合は滅多に使われないので通知する
      #   #   EXCEPTION_NOTIFICATION_ENABLE=1 foreman s
      #   # で確認できる
      #   behavior_after_rescue(error_html_build(error))
      else
        # http://lvh.me:3000/share-board.kif?body=position%20startpos%20moves%205i5e
        render plain: error.message
      end
    end
  end

  private

  def as_bs_error(error)
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
    s.join(" ").squish.presence
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
    s.html_safe
  end
end

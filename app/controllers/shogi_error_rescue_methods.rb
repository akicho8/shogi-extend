module ShogiErrorRescueMethods
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
        if params[:active_record_value_too_long]
          raise ActiveRecord::ValueTooLong, "(active_record_value_too_long)"
        end
      end
    end

    # 確認方法
    # http://localhost:4000/adapter?body=68S+active_record_value_too_long
    rescue_from "ActiveRecord::ValueTooLong" do |error|
      body = [error.message, params].join("\n")
      SlackAgent.notify(subject: error.class.name, body: body, channel: "#adapter_error")
      ExceptionNotifier.notify_exception(error, env: request.env, data: {params: params.to_unsafe_h})
      message = []
      message << "棋譜データがでかすぎです。"
      message << "KIF形式であればSFEN形式に変換してみてください。"
      message << "かなり小さくなるのでエラーを回避できるでしょう。"
      message << "「動画作成」のところなら「トリム」で0から最終手までを選択すればただのSFEN変換になります。"
      message << error.message
      message = message.join
      case
      when request.format.json?
        render json: { bs_error: { message: message } }, status: 200
      when request.format.png?
        send_file Rails.root.join("app/assets/images/fallback.png"), type: Mime[:png], disposition: "inline", status: 422
      else
        render plain: message
      end
    end

    rescue_from "Bioshogi::BioshogiError" do |error|
      if Rails.env.development?
        Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, error])
        Rails.logger.info(error.backtrace.join("\n"))
        sleep(0.5)
      end

      body = [error.message, params].join("\n")
      SlackAgent.notify(subject: error.class.name, body: body, channel: "#adapter_error")
      ExceptionNotifier.notify_exception(error, env: request.env, data: {params: params.to_unsafe_h})

      case
      when request.format.json?
        # 400で返すと axios.js のところにjsonの内容を返せないので結局200で返すしかない
        if params[:__STATUS_200_IF_ERROR__] || true
          status = 200          # なんでも棋譜変換だけ特別にエラーとせずアプリ内でエラーを表示する
        else
          status = 400
        end
        render json: as_bs_error(error), status: status
      when request.format.png?
        # https://developer.mozilla.org/ja/docs/Web/HTTP/Status/422
        send_file Rails.root.join("app/assets/images/fallback.png"), type: Mime[:png], disposition: "inline", status: 422
        # when request.format.html?
        #   # 野良棋譜投稿の場合は滅多に使われないので通知する
        #   #   EXCEPTION_NOTIFICATION_ENABLE=1 foreman s
        #   # で確認できる
        #   behavior_after_rescue(error_html_build(error))
      else
        # http://localhost:3000/share-board.kif?body=position%20startpos%20moves%205i5e
        render plain: error.message
      end
    end
  end

  private

  def as_bs_error(error)
    {
      bs_error: {
        :message_prefix => message_prefix_build(error),
        :message        => error.message.lines.first.strip,
        :board          => error.message.lines.drop(1).join,
      },
    }
  end

  def message_prefix_build(e)
    s = []
    if e.respond_to?(:xcontainer)
      s << "#{e.xcontainer.turn_info.display_turn.next}手目"
      s << "#{e.xcontainer.current_player.call_name}番"
    end
    if e.respond_to?(:input)
      s << "#{e.input.input.values.join}"
    end
    s.join(" ").squish.presence
  end
end

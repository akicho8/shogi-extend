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
      AppLog.critical(error)
      case
      when request.format.json?
        render json: { bs_error: BioshogiErrorFormatter.new(error).case_value_too_long }, status: 200
      when request.format.png?
        send_file Rails.root.join("app/assets/images/fallback.png"), type: Mime[:png], disposition: "inline", status: 422
      else
        render plain: BioshogiErrorFormatter.new(error).case_value_too_long
      end
    end

    rescue_from "Bioshogi::BioshogiError" do |error|
      if Rails.env.development?
        Rails.logger.info(error.backtrace.join("\n"))
        sleep(0.5)
      end

      if from_crawl_bot?
      else
        AppLog.critical(error, data: RequestInfo.new(self).to_s)
      end

      case
      when request.format.json? && params[:__ERROR_THEN_STATUS_200__]
        # 「なんでも棋譜変換」と「動画変換」
        render json: { bs_error: BioshogiErrorFormatter.new(error).to_h }, status: 200
      when request.format.json?
        # 共有将棋盤など
        render json: { primary_error_message: BioshogiErrorFormatter.new(error).to_s }, status: 400
      when request.format.png?
        send_file Rails.root.join("app/assets/images/fallback.png"), type: Mime[:png], disposition: "inline", status: 422
      else
        # http://localhost:3000/share-board.kif?body=position%20startpos%20moves%205i5e
        render plain: BioshogiErrorFormatter.new(error).to_s
      end
    end
  end
end

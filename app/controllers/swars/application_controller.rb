module Swars
  class ApplicationController < ::ApplicationController
    # 連打時にクロールが二重に走ってレコードが重複したときの状況を再現する
    # http://localhost:3000/w-user-stat?user_key=kinakom0chi&slow_processing=1
    # http://localhost:3000/w?query=kinakom0chi&slow_processing=1
    prepend_before_action do
      Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, params])

      p ["#{__FILE__}:#{__LINE__}", __method__, params[:slow_processing]]
      if params[:slow_processing]
        p ["#{__FILE__}:#{__LINE__}", __method__, params[:slow_processing]]
        raise ActiveRecord::RecordInvalid, Battle.create!(key: Battle.first.key)
      end
    end

    rescue_from "ActiveRecord::RecordInvalid" do |exception|
      p ["#{__FILE__}:#{__LINE__}", __method__, exception.record.errors.full_messages]

      if exception.record.errors[:key]
        p ["#{__FILE__}:#{__LINE__}", __method__, slow_processing_error_redirect_url]
        redirect_to slow_processing_error_redirect_url, alert: "データ収集中なのであと15秒ぐらいしてからお試しください"

        # MEMO: ここでガードリターン的な return をいれてはいけない。local jump error になってしまう
      else
        raise exception
      end
    end

    private

    # それぞれのコントローラーによってリダイレクト先が異なるのでオーバーライドしてもらう
    def slow_processing_error_redirect_url
      raise NotImplementedError, "#{__method__} is not implemented"
    end
  end
end

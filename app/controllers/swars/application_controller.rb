module Swars
  class ApplicationController < ::ApplicationController
    # 連打時にクロールが二重に走ってレコードが重複したときの状況を再現する
    # http://localhost:3000/w-user-stat?user_key=kinakom0chi&raise_duplicate_key_error=1
    # http://localhost:3000/w?query=kinakom0chi&raise_duplicate_key_error=1
    # https://www.shogi-extend.com/w?raise_duplicate_key_error=1
    if Rails.env.production? || Rails.env.staging?
    else
      prepend_before_action do
        if params[:raise_duplicate_key_error]
          raise ActiveRecord::RecordInvalid, Battle.create!(key: Battle.first.key)
        end
      end
    end

    rescue_from "ActiveRecord::RecordInvalid" do |exception|
      if exception.record.errors[:key]
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

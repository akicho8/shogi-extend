module FrontendScript
  class GifGenerateScript < Base
    include AtomicScript::PostRedirectMethods

    self.script_name = "リアルタイムアニメーション変換"

    def form_parts
      {
        :label   => "棋譜",
        :key     => :body,
        :type    => :text,
        :default => params[:body] || "68S",
      }
    end

    def script_body
      if Rails.env.production?
        raise "must not happen"
      end

      battle = FreeBattle.create!(kifu_body: params[:body])
      xconv_record = XconvRecord.create!(recordable: battle, user: h.current_user, convert_params: params)
      xconv_record.main_process!
      {
        browser_url: xconv_record.browser_url,
      }
    end

    def buttun_name
      "変換"
    end
  end
end

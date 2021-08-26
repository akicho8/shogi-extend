module FrontendScript
  class GifGenerateScript < Base
    include AtomicScript::PostRedirectMethods

    self.script_name = "リアルタイム動画生成"

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
      xmovie_record = XmovieRecord.create!(recordable: battle, user: h.current_user, convert_params: params)
      xmovie_record.main_process!
      {
        browser_url: xmovie_record.browser_url,
      }
    end

    def buttun_name
      "変換"
    end
  end
end

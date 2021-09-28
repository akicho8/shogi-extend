module FrontendScript
  class GifGenerateScript < Base
    include AtomicScript::PostRedirectMethods

    self.script_name = "リアルタイム動画作成"

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
      lemon = Kiwi::Lemon.create!(recordable: battle, user: h.current_user, all_params: params)
      lemon.main_process
      {
        browser_url: lemon.browser_url,
      }
    end

    def buttun_name
      "変換"
    end
  end
end

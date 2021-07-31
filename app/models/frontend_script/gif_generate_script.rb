module FrontendScript
  class GifGenerateScript < Base
    include AtomicScript::PostRedirectMethods

    self.script_name = "リアルタイムGIF変換"

    def form_parts
      {
        :label   => "棋譜",
        :key     => :body,
        :type    => :text,
        :default => params[:body] || "68S",
      }
    end

    def script_body
      battle = FreeBattle.create!(kifu_body: params[:body])
      henkan_record = HenkanRecord.create!(recordable: battle, user: h.current_user, generator_params: params)
      henkan_record.main_process!
      {
        browser_full_path: henkan_record.browser_full_path,
      }
    end

    def buttun_name
      "変換"
    end
  end
end

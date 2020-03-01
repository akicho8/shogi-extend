module EasyScript
  class ExampleRedirectScript < Base
    self.script_name = "いきなりリダイレクト"

    # 実行した瞬間飛ぶので特定ページのエイリアスとして利用可
    def script_body
      c.redirect_to(IndexScript.script_link_path)
    end
  end
end

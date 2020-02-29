module MyScript
  class ExampleRedirectScript < Base
    self.label_name = "いきなりリダイレクト"

    # 実行した瞬間飛ぶので特定ページのエイリアスとして利用可
    def script_body
      c.redirect_to(IndexScript.script_link_path)
    end
  end
end

module BackendScript
  class SwarsRegularUserScript < SwarsRecentlyUserScript
    self.category = "swars"
    self.script_name = "将棋ウォーズ棋譜検索 利用回数が多いユーザー"

    def records
      Swars::User.regular_only.limit(100)
    end
  end
end

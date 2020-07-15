module BackendScript
  class RegularUserScript < RecentlyUserScript
    self.category = "swars"
    self.script_name = "ウォーズ棋譜検索 利用回数が多いユーザー"

    def records
      Swars::User.regular_only.limit(100)
    end
  end
end

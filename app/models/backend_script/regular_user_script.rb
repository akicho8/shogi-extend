module BackendScript
  class RegularUserScript < RecentlyUserScript
    self.category = "ツール"
    self.script_name = "利用回数が多いユーザー"

    def records
      Swars::User.regular_only.limit(100)
    end
  end
end

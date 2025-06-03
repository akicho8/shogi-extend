module QuickScript
  module Swars
    OrderedIndex = [
      TacticListScript,
      TacticStatScript,
      TacticCrossScript,
      CrossSearchScript,

      # 分布系
      UserDistScript,
      StandardScoreScript,

      CrawlerBatchScript,

      BattleDownloadScript,
      SearchDefaultScript,
      DocumentationScript,
      UserGroupScript,
      ProScript,
      BattleHistoryScript,

      SearchScript,

      PrisonAllScript,
      PrisonSearchScript,
      PrisonNewScript,

      HourlyActiveUserScript,

      # スプリント先後勝率
      RuleWiseWinRateScript,
      SprintWinRateScript,

      # Mining 系
      TacticBattleMiningScript,
      GradeBattleMiningScript,
      PresetBattleMiningScript,
      StyleBattleMiningScript,
    ]
  end
end

module QuickScript
  module Swars
    OrderedIndex = [
      PlotScript,

      TacticListScript,         # 整合性？
      TacticStatScript,         # 整合性◎
      TacticCrossScript,        # 整合性？

      # 分布系
      UserDistScript,           # 整合性◎
      StandardScoreScript,      # 整合性◎

      CrawlerBatchScript,

      BattleDownloadScript,
      SearchDefaultScript,
      DocumentationScript,
      UserGroupScript,
      ProScript,
      BattleHistoryScript,

      SearchScript,

      HourlyActiveUserScript,   # 整合性◎

      # スプリント先後勝率
      RuleWiseWinRateScript,
      SprintWinRateScript,

      # Mining 系
      TacticBattleMiningScript,
      GradeBattleMiningScript,
      PresetBattleMiningScript,
      StyleBattleMiningScript,

      # 囚人系
      PrisonAllScript,
      PrisonSearchScript,
      PrisonNewScript,
    ]
  end
end

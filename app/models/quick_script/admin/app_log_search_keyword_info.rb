module QuickScript
  module Admin
    class AppLogSearchKeywordInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "基本",
          css_klass: "is-light",
          param_key: :query,
          keywords: [
            "短縮URL",
            "棋譜取得予約",
            "KENTO API",
            "ぴよ将棋",
            "短縮URL作成",
            "短縮URLリダイレクト",
            "ウォーズID不明",
            "囚人",
            "棋譜コピー",
            "ぴよ将棋起動",
            "KENTO起動",
            "SNS経由登録",
            "ユーザー新規登録",
            "一次集計完了",
          ],
        },
        {
          key: "共有将棋盤",
          css_klass: "is-primary is-light",
          param_key: :query,
          keywords: [
            "共有将棋盤",
            "チャット",
            "返答記録",
            "指手不達",
            "オーダー配布",
            "cc_behavior_start",
            "cc_behavior_silent_stop",
            "棋譜メール",
          ],
        },
        {
          key: "エラー",
          css_klass: "is-danger is-light",
          param_key: :query,
          keywords: ["RecordNotUnique", "Deadlocked"],
        },
        {
          key: "ログレベル",
          css_klass: "is-info is-light",
          param_key: :log_level_keys,
          keywords: LogLevelInfo.keys.reverse,
        },
      ]
    end
  end
end

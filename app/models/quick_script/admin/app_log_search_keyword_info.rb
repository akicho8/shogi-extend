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
            "将棋ドリル",
            "短縮URL",
            "KENTO API",
            "shogimap",
            "ぴよ将棋",
            "囚人",
            "棋譜コピー",
            "SNS経由登録",
            "ユーザー新規登録",
            "Googleスプレッドシート",
            "ZIP生成",
          ],
        },
        {
          key: "将棋ウォーズ",
          css_klass: "is-warning is-light",
          param_key: :query,
          keywords: [
            "ウォーズID記憶案内",
            "ウォーズID不明",
            "棋譜取得予約",
            "夜中棋譜取得",
            "ぴよ将棋起動",
            "KENTO起動",
            "一次集計完了",
            "横断棋譜検索",
            "将棋ウォーズ対局履歴",
          ],
        },
        {
          key: "共有将棋盤",
          css_klass: "is-primary is-light",
          param_key: :query,
          keywords: [
            "共有将棋盤",
            "チャット",
            "警告発動",
            "名前違反",
            "反則",
            "反則ブロック",
            "返答記録",
            "指手不達",
            "オーダー配布",
            "cc_behavior_start",
            "cc_behavior_silent_stop",
            "cc_behavior_silent_pause",
            "棋譜メール",
            "思考印導線",
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

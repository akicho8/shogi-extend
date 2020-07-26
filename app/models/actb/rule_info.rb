# -*- compile-command: "rails r 'Actb::Rule.setup; tp Actb::Rule'" -*-

module Actb
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      # 王手飛車 マニアックス
      { key: :test_rule,         name: "テスト用",             description: "テスト用全部入り・3点で勝ち",                             display_p: true,  strategy_key: :sy_singleton, development_only: true,  time_limit_sec: 15, controll_limit_sec: 5, best_questions_limit: 10, b_score_max_for_win:  3, turn_max: 1..7,  select_order: :random, after_order: :shuffle,    latest_move_to_top: 1.0, good_rate_gteq: 0.5, o_rate_gteq: 0.1, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "詰将棋(玉方持駒限定)"],               },
      { key: :good_rule,         name: "みんなのおすすめ問題", description: "10点先取で勝ち・考慮時間30秒",                            display_p: true,  strategy_key: :sy_singleton, development_only: false, time_limit_sec: 30, controll_limit_sec: 5, best_questions_limit: 30, b_score_max_for_win: 10, turn_max: nil,   select_order: :good,   after_order: nil,         latest_move_to_top: 1.0, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                                              },
      { key: :beginner_rule,     name: "早押し1〜3手詰",       description: "10点先取で勝ち・考慮時間30秒・実戦詰め筋を含む",          display_p: true,  strategy_key: :sy_singleton, development_only: false, time_limit_sec: 30, controll_limit_sec: 5, best_questions_limit: 20, b_score_max_for_win: 10, turn_max: 1..3,  select_order: :random, after_order: nil,         latest_move_to_top: 0.5, good_rate_gteq: 0.4, o_rate_gteq: 0.5, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "詰将棋(玉方持駒限定)", "実戦詰め筋"], },
      { key: :normal_rule,       name: "早押し5〜7手詰",       description: "5先取で勝ち・考慮時間45秒・実戦詰め筋を含む",             display_p: true,  strategy_key: :sy_singleton, development_only: false, time_limit_sec: 45, controll_limit_sec: 5, best_questions_limit: 20, b_score_max_for_win:  5, turn_max: 5..7,  select_order: :random, after_order: nil,         latest_move_to_top: 0.5, good_rate_gteq: 0.4, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "詰将棋(玉方持駒限定)", "実戦詰め筋"], },
      { key: :pro_rule,          name: "早押し9手詰以上",      description: "3点先取で勝ち・考慮時間60秒・実戦詰め筋を含む",           display_p: true,  strategy_key: :sy_singleton, development_only: false, time_limit_sec: 60, controll_limit_sec: 5, best_questions_limit: 20, b_score_max_for_win:  3, turn_max: 7..99, select_order: :random, after_order: nil,         latest_move_to_top: 0.5, good_rate_gteq: 0.4, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "詰将棋(玉方持駒限定)", "実戦詰め筋"], },
      { key: :technical_rule,    name: "早押し定跡＆手筋",     description: "5点先取で勝ち・考慮時間15秒・アヒル戦法は除外",           display_p: true,  strategy_key: :sy_singleton, development_only: false, time_limit_sec: 15, controll_limit_sec: 5, best_questions_limit: 20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: 0.5, good_rate_gteq: 0.4, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法", exclude: true],  lineage_keys_any: ["手筋", "定跡"],         },
      { key: :singleton_rule,    name: "全体ランダム",         description: "早押しクイズ形式",                                        display_p: true,  strategy_key: :sy_singleton, development_only: false, time_limit_sec: 10, controll_limit_sec: 5, best_questions_limit: 20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: 0.5, good_rate_gteq: 0.1, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :marathon_rule,     name: "全体ランダムマラソン", description: "じっくり自分のペースで考えたい人向け・先に5点先取で勝ち", display_p: true,  strategy_key: :sy_marathon,  development_only: false, time_limit_sec: 60, controll_limit_sec: 5, best_questions_limit: 20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: 0.5, good_rate_gteq: 0.1, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :hybrid_rule,       name: "ハイブリッド",         description: "マラソンルールだけど相手が解いたら次に進んじゃう",        display_p: false, strategy_key: :sy_hybrid,    development_only: false, time_limit_sec: 60, controll_limit_sec: 5, best_questions_limit: 20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: 0.5, good_rate_gteq: 0.1, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :latest_rule,       name: "新着問題",             description: "5点先取で勝ち・考慮時間30秒",                             display_p: true,  strategy_key: :sy_singleton, development_only: false, time_limit_sec: 30, controll_limit_sec: 5, best_questions_limit: 20, b_score_max_for_win:  5, turn_max: nil,   select_order: :latest, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :ahiru_only_rule,   name: "アヒル戦法ガチマッチ", description: "アヒルガチ勢専用・10点先取で勝ち",                        display_p: true,  strategy_key: :sy_singleton, development_only: false, time_limit_sec: 20, controll_limit_sec: 5, best_questions_limit: 20, b_score_max_for_win: 10, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: 0.5, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法"],                 lineage_keys_any: nil,                      },
      { key: :classic_only_rule, name: "古典詰将棋",           description: "5点先取で勝ち",                                           display_p: true,  strategy_key: :sy_singleton, development_only: false, time_limit_sec: 30, controll_limit_sec: 5, best_questions_limit: 10, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["古典詰将棋"],                 lineage_keys_any: nil,                      },
    ]

    class << self
      def default_key
        :marathon_rule
      end

      def as_json(*)
        super(only: [
            :key,                  # PK
            :name,                 # ルール名
            :description,          # 説明
            :display_p,            # ルール一覧に表示するか？
            :strategy_key,         # 出題方法(キーのリネーム可)
            :time_limit_sec,       # 問題が時間切れになるまでの秒数
            :controll_limit_sec,   # シングルトンのとき1手を操作できる秒数
            :best_questions_limit, # 用意する問題数
            :b_score_max_for_win,  # 指定ポイント取得で勝ちとする
          ])
      end
    end

    def display_p
      if development_only && !Rails.env.development?
        return false
      end

      super
    end

    def redis_key
      [self.class.name.demodulize.underscore, :matching_user_ids, key].join("/")
    end
  end
end

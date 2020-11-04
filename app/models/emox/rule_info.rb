# -*- compile-command: "rails r 'Emox::Rule.setup; tp Emox::Rule'" -*-

module Emox
  # rails r "tp Emox::RuleInfo.as_json"
  # rails r "puts Emox::RuleInfo.to_json"
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      # 王手飛車 マニアックス
      { key: :test_rule,          name: "テスト用",             description: "テスト用全部入り",                                 practice_only: true,  time_ranges: [("12:30"..."13:00"), ("00:00"..."23:55")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging"],               history_reject: true,  time_limit_sec: 15,  controll_limit_sec: 5, best_questions_limit:  10, b_score_max_for_win:  3, turn_max: nil,   select_order: :random, after_order: :shuffle,    latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,               },
      { key: :versus1_rule,       name: "実戦対局",             description: "",                                                 practice_only: false, time_ranges: [("12:30"..."13:00"), ("00:00"..."23:55")], strategy_key: :sy_versus,    available_envs: ["development", "test", "staging"],               history_reject: nil,   time_limit_sec: nil, controll_limit_sec: 5, best_questions_limit:   0, b_score_max_for_win:  3, turn_max: nil,   select_order: :random, after_order: :shuffle,    latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,               },
      { key: :good_rule,          name: "おすすめ問題",         description: "最初はここからどうぞ",                             practice_only: false, time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 20,  controll_limit_sec: 5, best_questions_limit:  50, b_score_max_for_win:  5, turn_max: 1..9,  select_order: :good,   after_order: :shuffle,    latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法", exclude: true],  lineage_keys_any: nil,                                              },
      { key: :good_marathon_rule, name: "おすすめとことん",     description: "マラソンモードでたくさん解く",                     practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_marathon,  available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 60,  controll_limit_sec: 5, best_questions_limit: 100, b_score_max_for_win: 20, turn_max: 1..9,  select_order: :good,   after_order: :shuffle,    latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法", exclude: true],  lineage_keys_any: nil,                                              },
      { key: :beginner_rule,      name: "1〜3手詰",             description: "実戦詰め筋を含む・評価50%未満除外",                practice_only: false, time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 30,  controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: 1..3,  select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: 0.5, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "玉方持駒限定の似非詰将棋", "実戦詰め筋"], },
      { key: :normal_rule,        name: "5〜7手詰",             description: "実戦詰め筋を含む・評価50%未満除外",                practice_only: false, time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 45,  controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: 5..7,  select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: 0.5, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "玉方持駒限定の似非詰将棋", "実戦詰め筋"], },
      { key: :pro_rule,           name: "9〜手詰",              description: "実戦詰め筋を含む・評価50%未満除外",                practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 60,  controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  3, turn_max: 9..99, select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: 0.5, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "玉方持駒限定の似非詰将棋", "実戦詰め筋"], },
      { key: :latest_rule,        name: "新着問題",             description: "",                                                 practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging", "production"], history_reject: false, time_limit_sec: 30,  controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: nil,   select_order: :latest, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :technical_rule,     name: "早押し定跡＆手筋",     description: "",                                                 practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 15,  controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: 1..9,  select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法", exclude: true],  lineage_keys_any: ["手筋", "定跡"],         },
      { key: :singleton_rule,     name: "全問ランダム",         description: "",                                                 practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 10,  controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :marathon_rule,      name: "全問ランダムマラソン", description: "盤を共有せず平行して解いていくルール",             practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_marathon,  available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 60,  controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :hybrid_rule,        name: "ハイブリッド",         description: "マラソンルールだけど相手が解いたら次に進む",       practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_hybrid,    available_envs: ["development", "test", "staging",],              history_reject: true,  time_limit_sec: 60,  controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :classic_only_rule,  name: "古典詰将棋",           description: "",                                                 practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 30,  controll_limit_sec: 5, best_questions_limit:  10, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["古典詰将棋"],                 lineage_keys_any: nil,                      },
      { key: :ahiru_only_rule,    name: "アヒル道場",           description: "アヒル戦法を覚えたい人向け",                       practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, available_envs: ["development", "test", "staging", "production"], history_reject: true,  time_limit_sec: 20,  controll_limit_sec: 5, best_questions_limit:  30, b_score_max_for_win: 10, turn_max: 1..9,  select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法"],                 lineage_keys_any: nil,                      },
    ]

    class << self
      def default_key
        :marathon_rule
      end

      def as_json(*)
        super({
            only: [
              :key,                  # PK
              :name,                 # ルール名
              :description,          # 説明
              :strategy_key,         # 出題方法(キーのリネーム可)
              :time_limit_sec,       # 問題が時間切れになるまでの秒数
              :controll_limit_sec,   # シングルトンのとき1手を操作できる秒数
              :best_questions_limit, # 用意する問題数
              :b_score_max_for_win,  # 指定ポイント取得で勝ちとする
              :practice_only,        # 練習のときだけ表示
            ],
            methods: [
              # :js_time_ranges,        # 有効な時間
              :display_p,            # ルール一覧に表示するか？
              :raw_time_ranges,
            ],
          })
      end
    end

    def display_p
      available_envs.include?(Rails.env)
    end

    # def time_ranges2
    #   (time_ranges || []).collect { |range|
    #     raise ArgumentError, range.inspect unless range.exclude_end?
    #     a = Time.zone.parse(range.begin)
    #     b = Time.zone.parse(range.end)
    #     a...b
    #   }
    # end

    # def js_time_ranges
    #   time_ranges2.collect { |range|
    #     { beg: range.begin, end: range.end }
    #   }
    # end

    def raw_time_ranges
      Array(time_ranges).collect { |range|
        raise ArgumentError, range.inspect unless range.exclude_end?
        { :beg => range.begin, :end => range.end }
      }
    end

    def redis_key
      [self.class.name.demodulize.underscore, :matching_user_ids, key].join("/")
    end
  end
end

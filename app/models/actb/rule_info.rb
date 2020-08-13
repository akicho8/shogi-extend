# -*- compile-command: "rails r 'Actb::Rule.setup; tp Actb::Rule'" -*-

module Actb
  # rails r "tp Actb::RuleInfo.as_json"
  # rails r "puts Actb::RuleInfo.to_json"
  # rails r "tp Actb::RuleInfo.first.generate"
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      # 王手飛車 マニアックス
      { key: :test_rule,          name: "テスト用",             description: "テスト用全部入り",                                 display_p: true,  practice_only: true,  time_ranges: [("12:30"..."13:00"), ("00:00"..."23:55")], strategy_key: :sy_singleton, development_only: true,  time_limit_sec: 15, controll_limit_sec: 5, best_questions_limit:  10, b_score_max_for_win:  3, turn_max: nil,   select_order: :random, after_order: :shuffle,    latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,               },
      { key: :good_rule,          name: "おすすめ問題",         description: "最初はここからどうぞ",                             display_p: true,  practice_only: false, time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, development_only: false, time_limit_sec: 20, controll_limit_sec: 5, best_questions_limit:  50, b_score_max_for_win:  5, turn_max: 1..9,  select_order: :good,   after_order: :shuffle,    latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法", exclude: true],  lineage_keys_any: nil,                                              },
      { key: :good_marathon_rule, name: "おすすめとことん",     description: "マラソンモードでたくさん解く",                     display_p: true,  practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_marathon,  development_only: false, time_limit_sec: 60, controll_limit_sec: 5, best_questions_limit: 100, b_score_max_for_win: 20, turn_max: 1..9,  select_order: :good,   after_order: :shuffle,    latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法", exclude: true],  lineage_keys_any: nil,                                              },
      { key: :beginner_rule,      name: "1〜3手詰",             description: "実戦詰め筋を含む・評価50%未満除外",                display_p: true,  practice_only: false, time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, development_only: false, time_limit_sec: 30, controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: 1..3,  select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: 0.5, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "玉方持駒限定の似非詰将棋", "実戦詰め筋"], },
      { key: :normal_rule,        name: "5〜7手詰",             description: "実戦詰め筋を含む・評価50%未満除外",                display_p: true,  practice_only: false, time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, development_only: false, time_limit_sec: 45, controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: 5..7,  select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: 0.5, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "玉方持駒限定の似非詰将棋", "実戦詰め筋"], },
      { key: :pro_rule,           name: "9〜手詰",              description: "実戦詰め筋を含む・評価50%未満除外",                display_p: true,  practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, development_only: false, time_limit_sec: 60, controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  3, turn_max: 9..99, select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: 0.5, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: ["詰将棋", "玉方持駒限定の似非詰将棋", "実戦詰め筋"], },
      { key: :latest_rule,        name: "新着問題",             description: "",                                                 display_p: true,  practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, development_only: false, time_limit_sec: 30, controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: nil,   select_order: :latest, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :technical_rule,     name: "早押し定跡＆手筋",     description: "",                                                 display_p: true,  practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, development_only: false, time_limit_sec: 15, controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: 1..9,  select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法", exclude: true],  lineage_keys_any: ["手筋", "定跡"],         },
      { key: :singleton_rule,     name: "全問ランダム",         description: "",                                                 display_p: true,  practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, development_only: false, time_limit_sec: 10, controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :marathon_rule,      name: "全問ランダムマラソン", description: "盤を共有せず平行して解いていくルール",             display_p: true,  practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_marathon,  development_only: false, time_limit_sec: 60, controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :hybrid_rule,        name: "ハイブリッド",         description: "マラソンルールだけど相手が解いたら次に進む",       display_p: false, practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_hybrid,    development_only: false, time_limit_sec: 60, controll_limit_sec: 5, best_questions_limit:  20, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: nil,                            lineage_keys_any: nil,                      },
      { key: :classic_only_rule,  name: "古典詰将棋",           description: "",                                                 display_p: true,  practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, development_only: false, time_limit_sec: 30, controll_limit_sec: 5, best_questions_limit:  10, b_score_max_for_win:  5, turn_max: nil,   select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["古典詰将棋"],                 lineage_keys_any: nil,                      },
      { key: :ahiru_only_rule,    name: "アヒル道場",           description: "アヒル戦法を覚えたい人向け",                       display_p: true,  practice_only: true,  time_ranges: [("12:30"..."13:00"), ("23:00"..."23:30")], strategy_key: :sy_singleton, development_only: false, time_limit_sec: 20, controll_limit_sec: 5, best_questions_limit:  30, b_score_max_for_win: 10, turn_max: 1..9,  select_order: :random, after_order: nil,         latest_move_to_top: nil, good_rate_gteq: nil, o_rate_gteq: nil, tagged_with_args: ["アヒル戦法"],                 lineage_keys_any: nil,                      },
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
              :display_p,            # ルール一覧に表示するか？
              :strategy_key,         # 出題方法(キーのリネーム可)
              :time_limit_sec,       # 問題が時間切れになるまでの秒数
              :controll_limit_sec,   # シングルトンのとき1手を操作できる秒数
              :best_questions_limit, # 用意する問題数
              :b_score_max_for_win,  # 指定ポイント取得で勝ちとする
              :practice_only,        # 練習のときだけ表示
            ],
            methods: [
              # :js_time_ranges,        # 有効な時間
              :raw_time_ranges,
            ],
          })
      end
    end

    def display_p
      if development_only
        if Rails.env.development?
          return true
        end
        # if Rails.env.staging?
        #   return true
        # end
        return false
      end

      super
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

    def db_scope
      s = Question.all
      s = s.active_only

      # 指定の評価以上のもの(good_rateが空のものは1.0と見なす)
      if v = rule.good_rate_gteq
        s = s.where("(good_rate IS NULL OR (good_rate >= ?))", v)
      end

      # 指定の正解率以上のもの(o_rateが空のものは1.0と見なす)
      if v = rule.o_rate_gteq
        s = s.joins(:ox_record).where("(o_rate IS NULL OR (o_rate >= ?))", v)
      end

      # 指定の手数のもの(Rangeでも指定可)
      if v = rule.turn_max
        s = s.where(turn_max: v)
      end

      # 指定のタグ(オプション含めて指定する)
      if v = rule.tagged_with_args
        s = s.tagged_with(*v)
      end

      # 指定の種類(複数指定可)
      if v = Array(rule.lineage_keys_any).presence
        s = s.where(lineage: v.collect { |e| Lineage.fetch(e) })
      end

      # 取得するまえに順番をどうするか
      case rule.select_order
      when :o_rate_desc
        s = s.joins(:ox_record).order(o_rate: :desc)
      when :random
        s = s.order("rand()")
      when :latest
        s = s.order(created_at: :desc)
      when :good
        s = s.order(Arel.sql("IFNULL(good_rate, 0) desc"))
      else
        raise ArgumentError, rule.select_order.inspect
      end

      s
    end

    def generate(users)
      s = db_scope

      # DBから取得
      raise unless rule.best_questions_limit
      s = s.limit(rule.best_questions_limit).to_a

      ################################################################################ 取得後

      # まぜる(DBから取得の際に何かの順序に依存していた場合など)
      case rule.after_order
      when :shuffle
        s = s.shuffle
        # when :turn_max_asc
        #   s = s.sort_by(&:turn_max)
        # when :o_rate_asc
        #   s = s.sort_by { |e| e.o_rate || 0 }
      end

      # 最近投稿されたN個だけランダムに最初の方に登場させる
      # Nは○問先取値に大きく依存しているので率を指定する
      # 20問DBから取得して、10問先取で勝ちで、この値が 0.3 なら
      # 10*0.3 の3問を、新しい順にした20問なかから取得して
      # ランダムに先頭の方に移動する
      if v = rule.latest_move_to_top
        n = (rule.b_score_max_for_win * v).round # n = 移動させるか個数
        ary = s.sort_by(&:created_at).last(n)         # 取得済みの20問のなかから最新n件を取得
        ary.shuffle.each do |e|                       # ランダムに前方に移動
          s = [e] + (s - [e])
        end
      end

      s.collect(&:as_json_type3)
    end

    private

    def rule
      self
    end
  end
end

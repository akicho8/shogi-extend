# frozen-string-literal: true

module Swars
  module User::Stat
    class BadgeStat < Base
      attr_reader :stat

      delegate *[
        :params,
        :tag_stat,
        :win_stat,
        :win_lose_streak_stat,
        :win_ratio,
      ], to: :stat

      def as_json
        [
          *badge_test,
          *active_badges.collect(&:badge_params),
        ]
      end

      def active_badges
        BadgeInfo.find_all { |e| instance_eval(&e.if_cond) || params[:badge_debug] }
      end

      def active_badge_keys
        @active_badge_keys ||= active_badges.collect(&:key).to_set
      end

      def to_set
        active_badge_keys
      end

      def active?(key)
        instance_eval(&BadgeInfo[key].if_cond)
      end

      def badge_test
        unless params[:badge_debug]
          return []
        end
        [
          { method: "tag",  name: "X", type: "is-white" },
          { method: "tag",  name: "X", type: "is-black" },
          { method: "tag",  name: "X", type: "is-light" },
          { method: "tag",  name: "X", type: "is-dark" },
          { method: "tag",  name: "X", type: "is-info" },
          { method: "tag",  name: "X", type: "is-success" },
          { method: "tag",  name: "X", type: "is-warning" },
          { method: "tag",  name: "X", type: "is-danger" },
          { method: "tag",  name: "💩", type: "is-white" },
          { method: "raw",  name: "💩" },
          { method: "icon", name: "link", type: "is-warning" },
        ]
      end

      def to_debug_hash
        {
          "対象サンプル数"      => stat.ids_count,
          "勝ち数"              => stat.win_count,
          "負け数"              => stat.lose_count,
          "居飛車率"            => stat.win_stat.ratios_hash[:"居飛車"],
          "振り飛車率"          => stat.win_stat.ratios_hash[:"振り飛車"],
          "居玉勝率"            => stat.win_stat.ratios_hash[:"居玉"],
          "アヒル囲い率"        => stat.win_stat.ratios_hash[:"アヒル囲い"],
          "嬉野流率"            => stat.win_stat.ratios_hash[:"嬉野流"],
          "棋風"                => stat.rarity_stat.ratios_hash,
          "1手詰を焦らした回数" => stat.mate_stat.count,
          "絶対投了しない回数"  => stat.leave_alone_stat.count,
          "棋神降臨疑惑対局数"  => stat.fraud_stat.count,
          "最大連勝連敗"        => stat.win_lose_streak_stat.to_h,
          "タグの重み"          => stat.win_stat.ratios_hash,
        }
      end

      # ボトルネックを探すときに使う
      # tp Swars::User.find_by!(user_key: "SugarHuuko").stat.badge_stat.time_stats
      def time_stats(sort: true)
        av = BadgeInfo.values.shuffle.collect { |e|
          if_cond = nil
          ms = Benchmark.ms { if_cond = !!instance_eval(&e.if_cond) }
          [ms, e, if_cond]
        }
        if sort
          av = av.sort_by { |ms, e, if_cond| -ms }
        end
        av.collect do |ms, e, if_cond|
          {
            "バッジ名" => e.name,
            "時間"     => "%.2f" % ms,
            "結果"     => if_cond ? "○" : "",
            "絵"       => e.badge_params[:name],
          }
        end
      end
    end
  end
end

# frozen-string-literal: true

module Swars
  module User::Stat
    class BadgeStat < Base
      delegate *[
        :params,
        :tag_stat,
        :win_stat,
        :win_lose_streak_stat,
        :win_ratio,
      ], to: :stat

      def as_json
        av = active_badges.collect { |e| { icon: e.icon, message: e.message } }
        av = av.shuffle
        if Rails.env.local?
          if badge_debug
            av = [
              { icon: "←", message: "左端" },
              *av,
              { icon: "→", message: "右端" },
            ]
          end
        end
        av
      end

      def active_badges
        BadgeInfo.find_all { |e| stat.instance_exec(&e.if_cond) || badge_debug }
      end

      def active_badge_keys
        @active_badge_keys ||= active_badges.collect(&:key).to_set
      end

      def to_set
        active_badge_keys
      end

      def active?(key)
        stat.instance_exec(&BadgeInfo[key].if_cond)
      end

      def to_debug_hash
        {
          "対象サンプル数"       => stat.ids_count,
          "勝ち数"               => stat.ids_scope.win_only.count,
          "負け数"               => stat.ids_scope.lose_only.count,
          "居飛車率"             => stat.win_stat.to_h[:"居飛車"],
          "振り飛車率"           => stat.win_stat.to_h[:"振り飛車"],
          "居玉勝率"             => stat.win_stat.to_h[:"居玉"],
          "アヒル囲い率"         => stat.win_stat.to_h[:"アヒル囲い"],
          "嬉野流率"             => stat.win_stat.to_h[:"嬉野流"],
          "棋風"                 => stat.style_stat.ratios_hash,
          "1手詰を焦らした回数"  => stat.taunt_mate_stat.count,
          "必勝形で焦らした回数" => stat.taunt_timeout_stat.count,
          "絶対投了しない回数"   => stat.leave_alone_stat.count,
          "棋神降臨疑惑対局数"   => stat.fraud_stat.count,
          "最大連勝連敗"         => stat.win_lose_streak_stat.to_h,
          "タグの重み"           => stat.win_stat.to_h,
        }
      end

      # ボトルネックを探すときに使う
      # tp Swars::User.find_by!(user_key: "SugarHuuko").stat.badge_stat.execution_time_explain
      def execution_time_explain(sort: true)
        av = BadgeInfo.values.shuffle.collect { |e|
          if_cond = nil
          ms = TimeTrial.ms { if_cond = !!stat.instance_exec(&e.if_cond) }
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
            "絵"       => e.icon,
          }
        end
      end
    end
  end
end

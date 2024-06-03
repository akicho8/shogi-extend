# frozen-string-literal: true

module Swars
  module UserStat
    class MedalStat < Base
      attr_reader :user_stat

      delegate *[
        :params,
        :win_tag,
        :all_tag,
        :consecutive_wins_and_losses_stat,
        :win_ratio,
      ], to: :user_stat

      def to_a
        list = matched_medal_infos.collect(&:medal_params)

        if params[:medal_debug]
          list << { method: "tag", name: "X", type: "is-white" }
          list << { method: "tag", name: "X", type: "is-black" }
          list << { method: "tag", name: "X", type: "is-light" }
          list << { method: "tag", name: "X", type: "is-dark" }
          list << { method: "tag", name: "X", type: "is-info" }
          # list << { method: "tag", name: "X", type: "is-success" }
          list << { method: "tag", name: "X", type: "is-warning" }
          # list << { method: "tag", name: "X", type: "is-danger" }
          list << { method: "tag", name: "💩", type: "is-white" }
          list << { method: "raw", name: "💩" }
          list << { method: "icon", name: "link", type: "is-warning" }
          # list << { method: "tag_with_icon", name: "pac-man", type: "is-warning", tag_wrap: { type: "is-black"} }
          # list << { method: "tag_with_icon", name: "timer-sand-empty", type: nil, tag_wrap: { type: "is-light" } }
        end

        list
      end

      def to_debug_hash
        {
          "対象サンプル数"          => user_stat.ids_count,
          "勝ち数"                  => user_stat.win_count,
          "負け数"                  => user_stat.lose_count,
          "勝率"                    => user_stat.win_ratio,
          "居飛車率"                => user_stat.all_tag.ratio(:"居飛車"),
          "振り飛車率"              => user_stat.all_tag.ratio(:"振り飛車"),
          "居玉勝率"                => user_stat.win_tag.ratio(:"居玉"),
          "アヒル囲い率"            => user_stat.all_tag.ratio(:"アヒル囲い"),
          "嬉野流率"                => user_stat.all_tag.ratio(:"嬉野流"),
          "棋風"                    => user_stat.rarity_stat.ratios_hash,
          "1手詰を焦らした回数"     => user_stat.mate_stat.count,
          "絶対投了しない回数"      => user_stat.leave_alone_stat.count,
          "棋神降臨疑惑対局数"      => user_stat.fraud_stat.count,
          "最大連勝連敗"            => user_stat.consecutive_wins_and_losses_stat.to_h,
          "タグの重み"              => user_stat.all_tag.counts_hash,
        }
      end

      def matched_medal_infos
        # if Rails.env.development?
        #   return MedalInfo
        # end
        MedalInfo.find_all { |e| instance_eval(&e.if_cond) || params[:medal_debug] }
      end

      def to_set
        @to_set ||= matched_medal_infos.collect(&:key).to_set
      end

      def active?(key)
        instance_eval(&MedalInfo[key].if_cond)
      end

      # ボトルネックを探すときに使う
      # tp Swars::User.find_by!(user_key: "SugarHuuko").user_stat.medal_stat.time_stats
      def time_stats(sort: true)
        av = MedalInfo.values.shuffle.collect { |e|
          if_cond = nil
          ms = Benchmark.ms { if_cond = !!instance_eval(&e.if_cond) }
          [ms, e, if_cond]
        }
        if sort
          av = av.sort_by { |ms, e, if_cond| -ms }
        end
        av.collect do |ms, e, if_cond|
          {
            "メダル名" => e.name,
            "時間"     => "%.2f" % ms,
            "結果"     => if_cond ? "○" : "",
            "絵"       => e.medal_params[:name],
          }
        end
      end

    end
  end
end

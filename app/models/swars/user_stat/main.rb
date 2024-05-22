# frozen-string-literal: true

module Swars
  module UserStat
    class Main
      include BaseScopeMethods
      include SubScopeMethods

      attr_accessor :user
      attr_accessor :params

      cattr_accessor(:default_params) {
        {
          :sample_max => 50, # データ対象直近n件
        }
      }

      def initialize(user, params = {})
        @user = user
        @params = default_params.merge(params)

        ActiveRecord::Base.logger.silence do
          AppLog.debug(emoji: ":参照:", subject: "プレイヤー情報参照", body: [user.key, params[:query]])
        end
      end

      # http://localhost:3000/w.json?query=kinakom0chi&format_type=user
      # http://localhost:3000/w.json?query=DevUser1&format_type=user
      # http://localhost:3000/w.json?query=DevUser1&format_type=user&debug=true
      # https://www.shogi-extend.com/w.json?query=kinakom0chi&format_type=user
      def to_hash
        {}.tap do |h|
          ################################################################################ メタ情報

          h[:onetime_key] = SecureRandom.hex # vue.js の :key に使うため
          h[:sample_max]  = sample_max       # サンプル数

          ################################################################################

          h.update(to_header_h)
          h.update(to_tabs_h)

          ################################################################################

          if Rails.env.local?
            h[:debug_hash]  = medal_stat.to_debug_hash
            h[:streak_stat] = streak_stat.to_h
          end
        end
      end

      def to_header_h
        {
          :user         => { key: user.key, ban_at: user.ban_at }, # 対象者情報
          :rule_items   => grade_stat.to_chart,                    # ルール別最高段位
          :judge_counts => ids_scope.total_judge_counts,           # 勝ち負け数
          :medal_stat   => medal_stat.to_a,                        # メダル一覧
          :judge_keys   => rjudge_stat.to_a,                       # 直近勝敗リスト
        }
      end

      def to_tabs_h
        {
          :day_items      => day_stat.to_chart, # 「日付」
          :vs_grade_items => vs_stat.to_chart,  # 「段級」
          **matrix_stat.to_all_chart,           # 「戦型」「対攻」「囲い」「対囲」
          :etc_items      => etc_stat.to_a,     # 「他」
        }
      end

      def as_json(*)
        to_hash
      end

      ################################################################################

      ################################################################################

      def win_tag
        @win_tag ||= TagStat.new(self, w_scope)
      end

      def all_tag
        @all_tag ||= TagStat.new(self, ids_scope)
      end

      def etc_stat
        @etc_stat ||= EtcStat.new(self)
      end

      def medal_stat
        @medal_stat ||= MedalStat.new(self)
      end

      def xmode_stat
        @xmode_stat ||= XmodeStat.new(self)
      end

      def rarity_stat
        @rarity_stat ||= RarityStat.new(self)
      end

      def migi_stat
        @migi_stat ||= MigiStat.new(self)
      end

      def tzone_stat
        @tzone_stat ||= TzoneStat.new(self)
      end

      def piece_stat
        @piece_stat ||= PieceStat.new(self)
      end

      def note_stat
        @note_stat ||= NoteStat.new(self)
      end

      def houti_stat
        @houti_stat ||= HoutiStat.new(self)
      end

      def streak_stat
        @streak_stat ||= StreakStat.new(self)
      end

      def toryo_stat
        @toryo_stat ||= ToryoStat.new(self)
      end

      def mate_stat
        @mate_stat ||= MateStat.new(self)
      end

      def think_stat
        @think_stat ||= ThinkStat.new(self)
      end

      def turn_stat
        @turn_stat ||= TurnStat.new(self)
      end

      def tavg_stat
        @tavg_stat ||= TavgStat.new(self)
      end

      def ttavg_stat
        @ttavg_stat ||= TtavgStat.new(self)
      end

      def matrix_stat
        @matrix_stat ||= MatrixStat.new(self)
      end

      def rage_stat
        @rage_stat ||= RageStat.new(self)
      end

      def mental_stat
        @mental_stat ||= MentalStat.new(self)
      end

      def final_stat
        @final_stat ||= FinalStat.new(self)
      end

      def day_stat
        @day_stat ||= DayStat.new(self)
      end

      def grade_stat
        @grade_stat ||= GradeStat.new(self)
      end

      def rule_stat
        @rule_stat ||= RuleStat.new(self)
      end

      def fraud_stat
        @fraud_stat ||= FraudStat.new(self)
      end

      def gdiff_stat
        @gdiff_stat ||= GdiffStat.new(self)
      end

      def bpd_stat
        @bpd_stat ||= BpdStat.new(self)
      end

      def vs_stat
        @vs_stat ||= VsStat.new(self)
      end

      def mspeed_stat
        @mspeed_stat ||= MspeedStat.new(self)
      end

      def rjudge_stat
        @rjudge_stat ||= RjudgeStat.new(self)
      end
    end
  end
end

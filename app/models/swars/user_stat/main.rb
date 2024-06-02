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
            h[:consecutive_wins_and_losses_stat] = consecutive_wins_and_losses_stat.to_h
          end
        end
      end

      def to_header_h
        {
          :user         => { key: user.key, ban_at: user.ban_at }, # 対象者情報
          :rule_items   => grade_by_rules_stat.to_chart,           # ルール別最高段位
          :judge_counts => total_judge_counts,                     # 勝ち負け数
          :medal_items  => medal_stat.to_a,                        # メダル一覧
          :judge_keys   => recent_outcome_list_stat.to_a,          # 直近勝敗リスト
        }
      end

      def to_tabs_h
        {
          :day_items      => daily_win_loss_list_stat.to_chart, # 「日付」
          :vs_grade_items => vs_stat.to_chart,                  # 「段級」
          **matrix_stat.to_all_chart,                           # 「戦型」「対攻」「囲い」「対囲」
          :etc_items      => other_stat.to_a,                   # 「他」
        }
      end

      def as_json(*)
        to_hash
      end

      ################################################################################

      def total_judge_counts
        @total_judge_counts ||= ids_scope.total_judge_counts
      end

      ################################################################################

      def win_tag
        @win_tag ||= TagStat.new(self, ids_scope.win_only)
      end

      def all_tag
        @all_tag ||= TagStat.new(self, ids_scope)
      end

      def other_stat
        @other_stat ||= OtherStat.new(self)
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

      def right_king_stat
        @right_king_stat ||= RightKingStat.new(self)
      end

      def match_time_period_stat
        @match_time_period_stat ||= MatchTimePeriodStat.new(self)
      end

      def piece_stat
        @piece_stat ||= PieceStat.new(self)
      end

      def note_stat
        @note_stat ||= NoteStat.new(self)
      end

      def leave_alone_stat
        @leave_alone_stat ||= LeaveAloneStat.new(self)
      end

      def consecutive_wins_and_losses_stat
        @consecutive_wins_and_losses_stat ||= ConsecutiveWinsAndLossesStat.new(self)
      end

      def resignation_stat
        @resignation_stat ||= ResignationStat.new(self)
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

      def average_moves_by_outcome_stat
        @average_moves_by_outcome_stat ||= AverageMovesByOutcomeStat.new(self)
      end

      def average_moves_at_resignation_stat
        @average_moves_at_resignation_stat ||= AverageMovesAtResignationStat.new(self)
      end

      def matrix_stat
        @matrix_stat ||= MatrixStat.new(self)
      end

      def checkmate_delay_enjoyment_stat
        @checkmate_delay_enjoyment_stat ||= CheckmateDelayEnjoymentStat.new(self)
      end

      def mental_stat
        @mental_stat ||= MentalStat.new(self)
      end

      def judge_final_stat
        @judge_final_stat ||= JudgeFinalStat.new(self)
      end

      def daily_win_loss_list_stat
        @daily_win_loss_list_stat ||= DailyWinLossListStat.new(self)
      end

      def grade_by_rules_stat
        @grade_by_rules_stat ||= GradeByRulesStat.new(self)
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

      def daily_average_matches_stat
        @daily_average_matches_stat ||= DailyAverageMatchesStat.new(self)
      end

      def vs_stat
        @vs_stat ||= VsStat.new(self)
      end

      def mate_speed_stat
        @mate_speed_stat ||= MateSpeedStat.new(self)
      end

      def recent_outcome_list_stat
        @recent_outcome_list_stat ||= RecentOutcomeListStat.new(self)
      end

      def lethargy_stat
        @lethargy_stat ||= LethargyStat.new(self)
      end

      def perpetual_check_stat
        @perpetual_check_stat ||= PerpetualCheckStat.new(self)
      end

      def taisekimati_stat
        @taisekimati_stat ||= TaisekimatiStat.new(self)
      end

      def prolonged_deliberation_stat
        @prolonged_deliberation_stat ||= ProlongedDeliberationStat.new(self)
      end

      def overthinking_loss_stat
        @overthinking_loss_stat ||= OverthinkingLossStat.new(self)
      end
    end
  end
end

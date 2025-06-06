# frozen-string-literal: true

module Swars
  module User::Stat
    class Main
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

        if Rails.env.local?
          ActiveRecord::Base.logger.silence do
            AppLog.debug(emoji: ":参照:", subject: "プレイヤー情報参照", body: [user.key, params[:query]])
          end
        end

        prepare
      end

      # https://www.shogi-extend.com/api/swars/user_stat.json?user_key=kinakom0chi
      # http://localhost:3000/api/swars/user_stat?user_key=BOUYATETSU5&sample_max=200
      # http://localhost:3000/api/swars/user_stat?user_key=kinakom0chi
      # http://localhost:3000/api/swars/user_stat?user_key=YamadaTaro&query=%E6%8C%81%E3%81%A1%E6%99%82%E9%96%93:10%E5%88%86
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
            h[:debug_hash] = badge_stat.to_debug_hash
            h[:win_lose_streak_stat] = win_lose_streak_stat.to_h
          end
        end
      end

      def to_header_h
        {
          :user          => { key: user.key, ban_at: user.ban_at }, # 対象者情報
          :display_ranks => display_rank_stat.display_ranks,        # ルール別最高段位
          :judge_counts  => total_judge_stat.counts_hash,           # 勝ち負け数
          :badge_items   => badge_stat.as_json,                     # バッジ一覧
          :judge_keys    => recent_outcome_list_stat.to_a,          # 直近勝敗リスト
        }
      end

      def to_tabs_h
        {
          :day_items      => daily_win_lose_list_stat.to_chart, # 「日付」
          :vs_grade_items => vs_stat.to_chart,                  # 「段級」
          **matrix_stat.to_all_chart,                           # 「戦法」「対攻」「囲い」「対囲」
          :etc_items      => other_stat.to_a,                   # 「他」
        }
      end

      def as_json(*)
        to_hash
      end

      def badge_debug
        params[:badge_debug]
      end

      ################################################################################

      # def total_judge_counts
      #   @total_judge_counts ||= ids_scope.total_judge_counts
      # end

      ################################################################################

      def my_scope
        @my_scope ||= ScopeExt.new(self, user.memberships)
      end
      delegate *ScopeExt::DELEGATE_METHODS, to: :my_scope

      def op_scope
        @op_scope ||= ScopeExt.new(self, user.op_memberships)
      end

      # さらに絞り込む対局IDs
      def filtered_battle_ids
        @filtered_battle_ids ||= yield_self do
          if query = params[:query]
            user.battles.find_all_by_query(query, target_owner: user).ids
          end
        end
      end

      ################################################################################

      def tag_stat
        @tag_stat ||= TagStat.new(self, my_scope)
      end

      def my_tag_stat
        tag_stat
      end

      def op_tag_stat
        @op_tag_stat ||= TagStat.new(self, op_scope)
      end

      def win_stat
        @win_stat ||= WinStat.new(self)
      end

      def other_stat
        @other_stat ||= OtherStat.new(self)
      end

      def badge_stat
        @badge_stat ||= BadgeStat.new(self)
      end

      def rapid_attack_stat
        @rapid_attack_stat ||= RapidAttackStat.new(self)
      end

      def xmode_stat
        @xmode_stat ||= XmodeStat.new(self)
      end

      def vitality_stat
        @vitality_stat ||= VitalityStat.new(self)
      end

      def total_judge_stat
        @total_judge_stat ||= TotalJudgeStat.new(self)
      end

      def rarity_stat
        @rarity_stat ||= RarityStat.new(self)
      end

      def style_stat
        @style_stat ||= StyleStat.new(self)
      end

      def right_king_stat
        @right_king_stat ||= RightKingStat.new(self)
      end

      def battle_time_hour_stat
        @battle_time_hour_stat ||= BattleTimeHourStat.new(self)
      end

      def battle_time_wday_stat
        @battle_time_wday_stat ||= BattleTimeWdayStat.new(self)
      end

      def piece_stat
        @piece_stat ||= PieceStat.new(self)
      end

      def piece_master_stat
        @piece_master_stat ||= PieceMasterStat.new(self)
      end

      def note_stat
        @note_stat ||= NoteStat.new(self)
      end

      def leave_alone_stat
        @leave_alone_stat ||= LeaveAloneStat.new(self)
      end

      def win_lose_streak_stat
        @win_lose_streak_stat ||= WinLoseStreakStat.new(self)
      end

      def resignation_stat
        @resignation_stat ||= ResignationStat.new(self)
      end

      def taunt_mate_stat
        @taunt_mate_stat ||= TauntMateStat.new(self)
      end

      def taunt_timeout_stat
        @taunt_timeout_stat ||= TauntTimeoutStat.new(self)
      end

      def think_stat
        @think_stat ||= ThinkStat.new(self)
      end

      def bad_tactic_stat
        @bad_tactic_stat ||= BadTacticStat.new(self)
      end

      def pro_skill_exceed_stat
        @pro_skill_exceed_stat ||= ProSkillExceedStat.new(self)
      end

      def turn_stat
        @turn_stat ||= TurnStat.new(self, ids_scope)
      end

      def win_turn_stat
        @win_turn_stat ||= TurnStat.new(self, ids_scope.win_only)
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

      def simple_matrix_stat
        @simple_matrix_stat ||= SimpleMatrixStat.new(self)
      end

      def mental_stat
        @mental_stat ||= MentalStat.new(self)
      end

      def judge_final_stat
        @judge_final_stat ||= JudgeFinalStat.new(self)
      end

      def unstable_network_stat
        @unstable_network_stat ||= UnstableNetworkStat.new(self)
      end

      def daily_win_lose_list_stat
        @daily_win_lose_list_stat ||= DailyWinLoseListStat.new(self)
      end

      def display_rank_stat
        @display_rank_stat ||= DisplayRankStat.new(self)
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

      def template_stat
        @template_stat ||= TemplateStat.new(self)
      end

      def daily_average_matches_stat
        @daily_average_matches_stat ||= DailyAverageMatchesStat.new(self)
      end

      def vs_stat
        @vs_stat ||= VsStat.new(self)
      end

      def xmode_judge_stat
        @xmode_judge_stat ||= XmodeJudgeStat.new(self)
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

      def skill_adjust_stat
        @skill_adjust_stat ||= SkillAdjustStat.new(self)
      end

      def draw_stat
        @draw_stat ||= DrawStat.new(self)
      end

      def gentleman_stat
        @gentleman_stat ||= GentlemanStat.new(self)
      end

      def waiting_to_leave_stat
        @waiting_to_leave_stat ||= WaitingToLeaveStat.new(self)
      end

      def prolonged_deliberation_stat
        @prolonged_deliberation_stat ||= ProlongedDeliberationStat.new(self)
      end

      def overthinking_loss_stat
        @overthinking_loss_stat ||= OverthinkingLossStat.new(self)
      end

      private

      def prepare
        @params[:badge_debug] = @params[:badge_debug].to_s.in?(["true", "1"])
      end
    end
  end
end

module Swars
  class Battle
    class CsaSeqToCsa
      CSA_COMMENT = "'"

      def initialize(battle)
        @battle = battle
      end

      def call
        to_csa
      end

      def to_csa
        @lines = []
        render_header
        render_body
        render_footer
        @lines.join("\n") + "\n"
      end

      private

      def render_header
        @lines << ["N+", @battle.memberships.first.name_with_grade].join
        @lines << ["N-", @battle.memberships.second.name_with_grade].join
        @lines << ["$START_TIME", @battle.battled_at.to_fs(:csa_ymdhms)] * ":"
        @lines << ["$EVENT", "#{event_title}(#{event_types.join(' ')})"] * ":"
        @lines << ["$TIME_LIMIT", @battle.rule_info.csa_time_limit] * ":"

        if true
          @lines << ["$X_FINAL", @battle.final_info.name] * ":" # 未使用
          if membership = @battle.memberships.find { |e| e.judge_key == "win" }
            @lines << ["$X_WINNER", membership.location_info.name] * ":" # 確実に勝者をパーサーに伝える (超重要)
          end
        end

        if @battle.preset_info.handicap
          @lines << @battle.preset_info.to_board.to_csa.strip
          @lines << "-"
        else
          @lines << "+"
        end
      end

      def render_body
        # 残り時間の並びから使用時間を求めつつ指し手と一緒に並べていく
        life = [@battle.rule_info.life_time] * @battle.memberships.size

        @battle.csa_seq.each.with_index do |(op, t), i|
          if true
            # 2024-12-25: 消費時間が nil になってい場合があるため 0 にしておく
            t ||= 0
          end

          i = i.modulo(life.size)
          used = life[i] - t
          life[i] = t

          # 【超重要】
          # ・将棋ウォーズの不具合で時間がマイナスになることがある
          # ・もともとはこれを容認していたがそれだとKIFの時間に負の値を書くことになる
          # ・そうするとKENTOで読めなくなるためしかたなくマイナスは0に補正している
          if used.negative?
            if Rails.env.test?
              raise "時間と対局モードが異なっている"
            end

            used = 0
          end

          @lines << "#{op},T#{used}"
        end
      end

      def render_footer
        @lines << @battle.final_info.csa_footer
        # @lines << "#{CSA_COMMENT} 結末: #{@battle.final_info.name}"
        # if membership = @battle.memberships.find { |e| e.judge_key == "win" }
        #   @lines << "#{CSA_COMMENT} 勝者: #{membership.location_key}"
        # end
      end

      def event_title
        "将棋ウォーズ"
      end

      def event_types
        av = []
        av << @battle.rule_info.long_name
        if @battle.xmode == Xmode.fetch("指導")
          av << "指導対局"
        end
        if @battle.preset_info.handicap
          av << @battle.preset_info.name
        end
        av
      end
    end
  end
end

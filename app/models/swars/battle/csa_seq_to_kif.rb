module Swars
  class Battle
    class CsaSeqToKif
      def initialize(record)
        @record = record
      end

      def to_kif
        @lines = []
        render_header
        render_body
        render_footer
        @lines.join("\n") + "\n"
      end

      private

      def render_header
        @lines << ["N+", @record.memberships.first.name_with_grade].join
        @lines << ["N-", @record.memberships.second.name_with_grade].join
        @lines << ["$START_TIME", @record.battled_at.to_s(:csa_ymdhms)] * ":"
        @lines << ["$EVENT", "#{event_title}(#{event_types.join(' ')})"] * ":"
        @lines << ["$TIME_LIMIT", @record.rule_info.csa_time_limit] * ":"
        if @record.preset_info.handicap
          @lines << @record.preset_info.to_board.to_csa.strip
          @lines << "-"
        else
          @lines << "+"
        end
      end

      def render_body
        # 残り時間の並びから使用時間を求めつつ指し手と一緒に並べていく
        life = [@record.rule_info.life_time] * @record.memberships.size
        @record.csa_seq.each.with_index do |(op, t), i|
          i = i.modulo(life.size)
          used = life[i] - t
          life[i] = t

          # 【超重要】
          # ・将棋ウォーズの不具合で時間がマイナスになることがある
          # ・もともとはこれを容認していたがそれだとKIFの時間に負の値を書くことになる
          # ・そうするとKENTOで読めなくなるためしかたなくマイナスは0に補正している
          if used.negative?
            used = 0
          end

          @lines << "#{op},T#{used}"
        end
      end

      def render_footer
        @lines << "%" + @record.final_info.csa_last_action_key
      end

      def event_title
        "将棋ウォーズ"
      end

      def event_types
        ary = []
        ary << @record.rule_info.long_name
        if @record.xmode == Xmode.fetch("指導")
          ary << "指導対局"
        end
        if @record.preset_info.handicap
          ary << @record.preset_info.name
        end
        ary
      end
    end
  end
end

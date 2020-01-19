module Swars
  class Battle
    concern :ConvertHookMethods do
      included do
        serialize :csa_seq
        attribute :kifu_body_for_test

        before_validation do
        end

        before_save do
          if (changes_to_save[:csa_seq] && csa_seq) || (changes_to_save[:kifu_body_for_test] && kifu_body_for_test)
            parser_exec
          end
        end
      end

      private

      def kifu_body
        kifu_body_for_test || kifu_body_from_csa_seq
      end

      def kifu_body_from_csa_seq
        type = []

        type << rule_info.long_name
        if memberships.any? { |e| e.grade.grade_info.key == :"十段" }
          type << "指導対局"
        end
        if preset_info.handicap
          type << preset_info.name
        end

        s = []
        s << ["N+", memberships.first.name_with_grade].join
        s << ["N-", memberships.second.name_with_grade].join
        s << ["$START_TIME", battled_at.to_s(:csa_ymdhms)] * ":"
        s << ["$EVENT", "将棋ウォーズ(#{type.join(' ')})"] * ":"
        s << ["$SITE", wars_url] * ":"
        s << ["$TIME_LIMIT", rule_info.csa_time_limit] * ":"

        # $OPENING は 戦型 のことで、これが判明するのはパースの後なのでいまはわからない。
        # それに自動的にあとから埋められるのでここは指定しなくてよい
        # s << "$OPENING:不明"

        if preset_info.handicap
          s << preset_info.to_board.to_csa.strip
          s << "-"
        else
          s << "+"
        end

        # 残り時間の並びから使用時間を求めつつ指し手と一緒に並べていく
        life = [rule_info.life_time] * memberships.size
        csa_seq.each.with_index do |(op, t), i|
          i = i.modulo(life.size)
          used = life[i] - t
          life[i] = t
          s << "#{op}"
          s << "T#{used}" # 将棋ウォーズの不具合で時間がマイナスになることがある
        end

        s << "%#{final_info.last_action_key}"
        s.join("\n") + "\n"
      end

      def fast_parsed_options
        {
          validate_skip: true,
          candidate_skip: true,
        }
      end

      def parser_exec_after(info)
        # 囲い対決などに使う
        if true
          info.mediator.players.each.with_index do |player, i|
            memberships[i].tap do |e|
              player.skill_set.to_h.each do |key, values|
                if AppConfig[:swars_tag_search_function]
                  e.send("#{key}_tag_list=", values)
                else
                  if [:attack, :defense].include?(key)
                    e.send("#{key}_tag_list=", values)
                  end
                end
              end
            end
          end
        end

        if AppConfig[:swars_tag_search_function]
          memberships.each do |e|
            if e.grade.grade_info.key == :"十段"
              e.note_tag_list.add "指導対局"
              note_tag_list.add "指導対局"
            end
          end

          other_tag_list.add preset_info.name
          if preset_info.handicap
            other_tag_list.add "駒落ち"
          end

          other_tag_list.add rule_info.name
          other_tag_list.add final_info.name
        end
      end
    end
  end
end

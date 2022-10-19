module Swars
  class Battle
    concern :CoreMethods do
      included do
        serialize :csa_seq
        attr_accessor :kifu_body_for_test
        attr_accessor :tactic_key

        before_save do
          if tactic_key || kifu_body_for_test || (will_save_change_to_attribute?(:csa_seq) && csa_seq)
            parser_exec
          end
        end
      end

      def kifu_body
        if tactic_key
          return Bioshogi::TacticInfo.flat_lookup(tactic_key).sample_kif_file.read
        end
        kifu_body_for_test || kifu_body_from_csa_seq
      end

      # 駒の使用頻度の情報がなければ保存
      # Swars::Battle.find_each(&:membership_extra_create_if_nothing) }
      def membership_extra_create_if_nothing
        if m = memberships.first
          if !m.membership_extra
            membership_extra_build_if_nothing
            memberships.each { |e| e.membership_extra.save! }
          end
        end
      end

      # 駒の使用頻度を保存
      def membership_extra_build_if_nothing
        fast_parsed_info.xcontainer.players.each.with_index do |player, i|
          m = memberships[i]
          if !m.membership_extra
            m.build_membership_extra(used_piece_counts: player.used_piece_counts)
          end
        end
      end

      private

      def kifu_body_from_csa_seq
        type = []

        type << rule_info.long_name
        if xmode == Xmode.fetch("指導")
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
        # s << ["$SITE", official_swars_battle_url] * ":"
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

          if true
            # 【超重要】
            # ・将棋ウォーズの不具合で時間がマイナスになることがある
            # ・もともとはこれを容認していた
            # ・しかしKIFの時間に負の値を書くことになる
            # ・するとKENTOが転ける
            if used.negative?
              used = 0
            end
          end

          s << "#{op},T#{used}"
        end

        s << "%#{final_info.csa_last_action_key}"
        s.join("\n") + "\n"
      end

      def fast_parser_options
        {
          :validate_enable  => false,
          :candidate_enable => false,
        }
      end

      def parser_exec_after(info)
        memberships.each(&:think_columns_update)

        # 駒の使用頻度を保存
        membership_extra_build_if_nothing

        # 囲い対決などに使う
        if true
          info.xcontainer.players.each.with_index do |player, i|
            memberships[i].tap do |e|
              player.skill_set.to_h.each do |key, values|
                e.send("#{key}_tag_list=", values - (reject_tag_keys[key] || []))
              end
            end
          end
        end

        if AppConfig[:swars_tag_search_function]
          if false
            memberships.each do |e|
              if e.grade.grade_info.key == :"十段"
                e.note_tag_list.add "指導対局"
                note_tag_list.add "指導対局"
              end
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

module Swars
  class Battle
    concern :ConvertHookMethods do
      included do
        serialize :csa_seq
        attribute :kifu_body_for_test
        attribute :tactic_key

        before_save do
          if (changes_to_save[:tactic_key] && tactic_key) || (changes_to_save[:kifu_body_for_test] && kifu_body_for_test) || (changes_to_save[:csa_seq] && csa_seq)
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

      private

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
        s << ["$SITE", official_swars_battle_url] * ":"
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

          if true
            # 【超重要】
            # ・将棋ウォーズの不具合で時間がマイナスになることがある
            # ・もともとはこれを容認していた
            # ・しかしKIFの時間のところに負の値を書くことになる
            # ・するとKENTOで使っているKIFパースライブラリで、ハイフンを受け付けずに転ける
            if used.negative?
              used = 0
            end
          end

          s << "T#{used}"
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
        # いちばん考えた時間(放置時間切れを含む)
        info.mediator.players.each_index do |i|
          memberships[i].tap do |e|
            e.think_max = e.sec_list.max || 0
            e.think_last = e.sec_list.last || 0

            sec_list = e.sec_list

            if Rails.env.development? || Rails.env.test?
              sec_list = sec_list.compact # パックマン戦法のKIFには時間が入ってなくて、その場合、時間が nil になるため。ただしそれは基本開発環境のみ。
            end

            d = sec_list.size
            c = sec_list.sum
            if d.positive?
              e.think_all_avg = c.div(d)
            end

            list = sec_list.last(5)
            d = list.size
            c = list.sum
            if d.positive?
              e.think_end_avg = c.div(d)
            end

            a = sec_list                               # => [2, 3, 3, 2, 2, 2]
            x = a.chunk { |e| e == 2 }                 # => [[true, [2]], [false, [3, 3], [true, [2, 2, 2]]
            x = x.collect { |k, v| k ? v.size : nil }  # => [       1,            nil,           3        ]
            v = x.compact.max                          # => 3
            if v
              e.two_serial_max = v
            end
          end
        end

        # 囲い対決などに使う
        if true
          info.mediator.players.each.with_index do |player, i|
            memberships[i].tap do |e|
              player.skill_set.to_h.each do |key, values|
                e.send("#{key}_tag_list=", values - (reject_tag_keys[key] || []))
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

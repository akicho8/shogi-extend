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
          return Bioshogi::Explain::TacticInfo.flat_lookup(tactic_key).sample_kif_file.read
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
        CsaSeqToKif.new(self).to_kif
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

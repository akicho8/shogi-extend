module Swars
  class Battle
    concern :CoreMethods do
      included do
        serialize :csa_seq
        attr_accessor :kifu_body_for_test
        attr_accessor :tactic_key
        # attr_accessor :kifu_generator

        before_save do
          if tactic_key || kifu_body_for_test || (will_save_change_to_attribute?(:csa_seq) && csa_seq)
            parser_exec
          end
        end
      end

      def kifu_body
        if tactic_key
          return Bioshogi::Analysis::TacticInfo.flat_lookup(tactic_key).main_reference_file.read
        end
        kifu_body_for_test || to_temporary_csa
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
        fast_parsed_info.container.players.each.with_index do |player, i|
          m = memberships[i]
          if !m.membership_extra
            m.build_membership_extra(used_piece_counts: player.used_piece_counts)
          end
        end
      end

      def to_temporary_csa
        CsaSeqToCsa.new(self).to_csa
      end

      private

      def fast_parser_options
        {
          :validate_enable  => false,
          :candidate_enable => false,
        }
      end

      def parser_exec_after(info)
        self.analysis_version = Bioshogi::ANALYSIS_VERSION

        memberships.each(&:think_columns_update)

        # 駒の使用頻度を保存
        membership_extra_build_if_nothing

        # 囲い対決・得点
        if true
          info.container.players.each.with_index do |player, i|
            memberships[i].tap do |e|
              player.skill_set.to_h.each do |key, values|
                e.send("#{key}_tag_list=", values - (reject_tag_keys[key] || []))
              end
              e.ek_score_without_cond = player.ek_score_without_cond
              e.ek_score_with_cond = player.ek_score_with_cond
            end
          end
        end

        style_update_all(info)
      end

      def style_update_all(info)
        info.container.players.each.with_index do |player, i|
          memberships[i].style_update(player)
        end
      end
    end
  end
end

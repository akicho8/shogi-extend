# frozen-string-literal: true

module Swars
  module User::Stat
    class MatrixStat < Base
      delegate *[
        :my_tag_stat,
        :op_tag_stat,
      ], to: :stat

      def to_all_chart
        hv = {
          :my_attack_items    => my_attack_items,
          :vs_attack_items    => vs_attack_items,
          :my_defense_items   => my_defense_items,
          :vs_defense_items   => vs_defense_items,
          :my_technique_items => my_technique_items,
          :vs_technique_items => vs_technique_items,
        }
        if Rails.env.local?
          hv.update({
              :my_note_items => my_note_items,
              :vs_note_items => vs_note_items,
            })
        end
        hv
      end

      # 戦法 x 自分
      def my_attack_items
        list_build_by(my_tag_stat, :attack_tags, swap: false)
      end

      # 戦法 x 相手
      def vs_attack_items
        list_build_by(op_tag_stat, :attack_tags, swap: true)
      end

      # 囲い x 自分
      def my_defense_items
        list_build_by(my_tag_stat, :defense_tags, swap: false)
      end

      # 囲い x 相手
      def vs_defense_items
        list_build_by(op_tag_stat, :defense_tags, swap: true)
      end

      # 技 x 自分
      def my_technique_items
        list_build_by(my_tag_stat, :technique_tags, swap: false)
      end

      # 技 x 相手
      def vs_technique_items
        list_build_by(op_tag_stat, :technique_tags, swap: true)
      end

      # 備考 x 自分
      def my_note_items
        list_build_by(my_tag_stat, :note_tags, swap: false)
      end

      # 備考 x 相手
      def vs_note_items
        list_build_by(op_tag_stat, :note_tags, swap: true)
      end

      private

      def list_build_by(tag_stat, context, options = {})
        scope_ext = tag_stat.scope_ext
        tags = scope_ext.ids_scope.tag_counts_on(context, order: "count DESC")
        tags.each_with_object([]) do |tag, av|
          if v = tag_stat.tag_chart_build(tag.name.to_sym, options)
            av << v
          end
        end
      end
    end
  end
end

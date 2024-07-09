# frozen-string-literal: true

module Swars
  module User::Stat
    class SimpleMatrixStat < Base
      delegate *[
        :my_tag_stat,
        :op_tag_stat,
      ], to: :stat

      # def to_all_chart
      #   hv = {
      #     :my_attack_tag    => my_attack_tag,
      #     :vs_attack_tag    => vs_attack_tag,
      #     :my_defense_tag   => my_defense_tag,
      #     :vs_defense_tag   => vs_defense_tag,
      #     :my_technique_tag => my_technique_tag,
      #     :vs_technique_tag => vs_technique_tag,
      #   }
      #   if Rails.env.local?
      #     hv.update({
      #         :my_note_tag => my_note_tag,
      #         :vs_note_tag => vs_note_tag,
      #       })
      #   end
      #   hv
      # end

      # 戦法 x 自分
      def my_attack_tag
        @my_attack_tag ||= find_one(my_tag_stat, :attack_tags)
      end

      # # 戦法 x 相手
      # def vs_attack_tag
      #   @vs_attack_tag ||= find_one(op_tag_stat, :attack_tags)
      # end

      # 囲い x 自分
      def my_defense_tag
        find_one(my_tag_stat, :defense_tags, swap: false)
      end

      # # 囲い x 相手
      # def vs_defense_tag
      #   find_one(op_tag_stat, :defense_tags, swap: true)
      # end
      #
      # # 技 x 自分
      # def my_technique_tag
      #   find_one(my_tag_stat, :technique_tags, swap: false)
      # end
      #
      # # 技 x 相手
      # def vs_technique_tag
      #   find_one(op_tag_stat, :technique_tags, swap: true)
      # end
      #
      # # 備考 x 自分
      # def my_note_tag
      #   find_one(my_tag_stat, :note_tags, swap: false)
      # end
      #
      # # 備考 x 相手
      # def vs_note_tag
      #   find_one(op_tag_stat, :note_tags, swap: true)
      # end

      # private

      def find_one(tag_stat, context, options = {})
        scope_ext = tag_stat.scope_ext
        tags = scope_ext.ids_scope.tag_counts_on(context, order: "count DESC, tags.id ASC", limit: 1) # count だけだと揺らぐため
        # tags.each_with_object([]) do |tag, av|
        #   if v = tag_stat.tag_chart_build(tag.name.to_sym, options)
        #     av << v
        #   end
        # end
        tags.first
      end
    end
  end
end

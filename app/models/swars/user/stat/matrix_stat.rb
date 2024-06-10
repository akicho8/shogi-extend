# frozen-string-literal: true

module Swars
  module User::Stat
    class MatrixStat < Base
      delegate *[
        :my_tag_stat,
        :op_tag_stat,
      ], to: :@stat

      def to_all_chart
        {
          :my_attack_items  => my_attack_items,
          :vs_attack_items  => vs_attack_items,
          :my_defense_items => my_defense_items,
          :vs_defense_items => vs_defense_items,
        }
      end

      # 戦法 x 自分
      def my_attack_items
        build_by(my_tag_stat, :attack_tags)
      end

      # 戦法 x 相手
      def vs_attack_items
        build_by(op_tag_stat, :attack_tags)
      end

      # 囲い x 自分
      def my_defense_items
        build_by(my_tag_stat, :defense_tags)
      end

      # 囲い x 相手
      def vs_defense_items
        build_by(op_tag_stat, :defense_tags)
      end

      private

      def build_by(tag_stat, context)
        scope_ext = tag_stat.scope_ext
        tags = scope_ext.ids_scope.tag_counts_on(context, order: "count DESC")
        tags.each_with_object([]) do |tag, av|
          if judge_counts = tag_stat.to_win_lose_h(tag.name.to_sym)
            if tag_stat == op_tag_stat
              judge_counts[:win], judge_counts[:lose] = judge_counts[:lose], judge_counts[:win]
            end
            av << {
              :tag          => tag.attributes.slice("name", "count"), # 戦法名・個数
              :appear_ratio => tag.count.fdiv(scope_ext.ids_count),   # 遭遇率
              :judge_counts => judge_counts,                          # 勝敗数
            }
          else
            # 引き分けしかない場合
          end
        end
      end
    end
  end
end

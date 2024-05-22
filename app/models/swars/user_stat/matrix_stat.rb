# frozen-string-literal: true

module Swars
  module UserStat
    class MatrixStat < Base
      delegate *[
        :user,
        :base_cond,
      ], to: :@user_stat

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
        build_by(user.memberships, context: :attack_tags)
      end

      # 戦法 x 相手
      def vs_attack_items
        build_by(user.op_memberships, context: :attack_tags, judge_flip: true)
      end

      # 囲い x 自分
      def my_defense_items
        build_by(user.memberships, context: :defense_tags)
      end

      # 囲い x 相手
      def vs_defense_items
        build_by(user.op_memberships, context: :defense_tags, judge_flip: true)
      end

      private

      def build_by(memberships, options = {})
        s = base_cond(memberships)
        ids = s.ids
        denominator = ids.size

        # ここの再スコープは JOIN を除いた SQL にするためではなく sample_max 件で最初に絞らないといけない
        # 副作用として若干速くもなる
        s = Membership.where(id: ids)

        tags = s.tag_counts_on(options[:context], order: "count desc")
        tags.collect do |tag|
          {}.tap do |h|
            # 戦法名
            h[:tag] = tag.attributes.slice("name", "count")

            # 使用頻度, 遭遇率
            h[:appear_ratio] = tag.count.fdiv(denominator)

            # 勝ち負け数
            c = s.tagged_with(tag.name, on: options[:context]).s_group_judge_key.count
            if options[:judge_flip]
              c["win"], c["lose"] = c["lose"], c["win"] # => {"win" => 0, "lose" => 1}    ; 自分視点に変更
            end
            h[:judge_counts] = c
          end
        end
      end
    end
  end
end

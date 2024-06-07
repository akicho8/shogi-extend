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
        build_by(my_scope_ids, context: :attack_tags)
      end

      # 戦法 x 相手
      def vs_attack_items
        build_by(vs_scope_ids, context: :attack_tags, judge_flip: true)
      end

      # 囲い x 自分
      def my_defense_items
        build_by(my_scope_ids, context: :defense_tags)
      end

      # 囲い x 相手
      def vs_defense_items
        build_by(vs_scope_ids, context: :defense_tags, judge_flip: true)
      end

      private

      def my_scope_ids
        @my_scope_ids ||= base_cond(user.memberships).ids
      end

      def vs_scope_ids
        @vs_scope_ids ||= base_cond(user.op_memberships).ids
      end

      def build_by(ids, options = {})
        # ここの再スコープは JOIN を除いた SQL にするためではなく sample_max 件で最初に絞らないといけない
        # 副作用として若干速くもなる
        s = Membership.where(id: ids)

        tags = s.tag_counts_on(options[:context], order: "count DESC")
        tags.collect do |tag|
          {}.tap do |h|
            # 戦法名
            h[:tag] = tag.attributes.slice("name", "count")

            # 使用頻度, 遭遇率
            h[:appear_ratio] = tag.count.fdiv(ids.size)

            # 勝ち負け数

            # 注意:
            #
            #  ActsAsTaggableOn.force_binary_collation = true
            #  または
            #  ActsAsTaggableOn.strict_case_match = true
            #  で
            #  c = s.tagged_with(tag.name, on: options[:context]).s_group_judge_key.count
            #  を実行すると membership が 200 件にもかかわらず 43 秒かかる。
            #

            # 上記の条件でなければ on: options[:context] を指定してもいいが、
            # まず、指定する効果がないため常に指定しないでよい
            if false
              c = s.tagged_with(tag.name, on: options[:context]).s_group_judge_key.count # strict_case_match が有効だと激重になる
            else
              c = s.tagged_with(tag.name).s_group_judge_key.count
            end
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

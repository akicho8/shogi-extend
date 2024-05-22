# frozen-string-literal: true

module Swars
  module UserStat
    class VsStat < Base
      delegate *[
        :user,
        :base_cond,
      ], to: :@user_stat

      # 対段級
      def to_chart
        s = ids_scope
        s = s.joins(:grade).group(Grade.arel_table[:key]) # 段級と
        s = s.joins(:judge).group(Judge.arel_table[:key]) # 勝ち負けでグループ化
        s = s.order(Grade.arel_table[:priority].asc)      # 相手が強い順
        hash = s.count

        # tp hash
        # >> |------------------+----|
        # >> | ["八段", "draw"] | 2  |
        # >> |  ["七段", "win"] | 5  |
        # >> | ["七段", "lose"] | 6  |
        # >> | ["六段", "lose"] | 14 |
        # >> |  ["六段", "win"] | 1  |
        # >> | ["五段", "lose"] | 11 |
        # >> |  ["五段", "win"] | 2  |
        # >> | ["四段", "lose"] | 6  |
        # >> | ["四段", "draw"] | 1  |
        # >> | ["三段", "lose"] | 1  |
        # >> |  ["9級", "lose"] | 1  |
        # >> |------------------+----|

        counts = {}
        hash.each do |(grade_key, judge_key), count|
          judge_info = JudgeInfo.fetch(judge_key)
          counts[grade_key] ||= {}
          counts[grade_key][judge_info.flip.key] = count
        end

        # tp counts
        # >> |------+----------------------|
        # >> | 八段 | {:draw=>2}           |
        # >> | 七段 | {:lose=>5, :win=>6}  |
        # >> | 六段 | {:win=>14, :lose=>1} |
        # >> | 五段 | {:win=>11, :lose=>2} |
        # >> | 四段 | {:win=>6, :draw=>1}  |
        # >> | 三段 | {:win=>1}            |
        # >> |  9級 | {:win=>1}            |
        # >> |------+----------------------|

        av = counts.collect do |k, v|
          total = v.sum { |_, c| c }
          {
            :grade_name   => k,                       # 段級
            :judge_counts => v,                       # 勝敗
            :appear_ratio => total.fdiv(denominator), # 遭遇率
          }
        end

        # tp av
        # >> |------------+----------------------+--------------|
        # >> | grade_name | judge_counts         | appear_ratio |
        # >> |------------+----------------------+--------------|
        # >> | 八段       | {:draw=>2}           |         0.04 |
        # >> | 七段       | {:lose=>5, :win=>6}  |         0.22 |
        # >> | 六段       | {:win=>14, :lose=>1} |          0.3 |
        # >> | 五段       | {:win=>11, :lose=>2} |         0.26 |
        # >> | 四段       | {:win=>6, :draw=>1}  |         0.14 |
        # >> | 三段       | {:win=>1}            |         0.02 |
        # >> | 9級        | {:win=>1}            |         0.02 |
        # >> |------------+----------------------+--------------|

        av
      end

      private

      def ids_scope
        @ids_scope ||= Membership.where(id: ids)
      end

      def denominator
        @denominator ||= ids.size
      end

      def ids
        @ids ||= base_cond(user.op_memberships).ids
      end
    end
  end
end

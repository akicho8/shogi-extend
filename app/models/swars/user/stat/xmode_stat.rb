# frozen-string-literal: true

module Swars
  module User::Stat
    class XmodeStat < Base
      delegate *[
        :ids_scope,
        :user,
      ], to: :@stat

      # 指導対局を受けた？
      # 自分がプロではない条件を入れないと先生も指導を受けたことになってしまう
      def versus_pro?
        exist?(:"指導") && !user.grade_info.teacher
      end

      def exist?(xmode_key)
        assert_xmode_key(xmode_key)
        counts_hash.has_key?(xmode_key)
      end

      def count(xmode_key)
        assert_xmode_key(xmode_key)
        counts_hash.fetch(xmode_key, 0)
      end

      def to_chart
        @to_chart ||= yield_self do
          if counts_hash.present?
            XmodeInfo.collect do |e|
              { name: e.name, value: count(e.key) }
            end
          end
        end
      end

      def counts_hash
        @counts_hash ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => :xmode)
          s = s.group(Xmode.arel_table[:key])
          s.count.symbolize_keys
        end
      end
    end
  end
end

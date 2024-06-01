# frozen-string-literal: true

module Swars
  module UserStat
    class ResignationStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      # 投了までの心の準備
      def to_chart
        if max
          sep_min = 1.minutes
          sep_sec = 10.seconds
          list = []

          # 1分未満は10分割
          s = scope
          s = s.where(Membership.arel_table[:think_last].lt(sep_min))
          h = s.group("think_last DIV #{sep_sec}").order("count_all desc").count
          if h.present?
            h.each do |quotient, count|
              if quotient.zero?
                name = "#{sep_sec}秒未満"
              else
                name = "#{quotient * sep_sec}秒"
              end
              list << { name: name, value: count }
            end
          end

          # 1分以上
          if max >= sep_min
            s = scope
            s = s.where(Membership.arel_table[:think_last].gteq(sep_min))
            h = s.group("think_last DIV #{sep_min}").order("count_all desc").count
            if h.present?
              h.each do |quotient, count|
                list << { name: "#{quotient}分", value: count }
              end
            end
          end

          list
        end
      end

      # 投了までの心の準備(平均)
      def max
        @max ||= scope.maximum(:think_last)
      end

      # 投了までの心の準備(最長)
      def average
        @average ||= yield_self do
          if v = scope.average(:think_last)
            v.to_f.round(2)
          end
        end
      end

      private

      def scope
        @scope ||= yield_self do
          s = ids_scope.lose_only
          s = s.joins(:battle => :final)
          s = s.where(Battle.arel_table[:turn_max].gteq(14))
          s = s.where(Final.arel_table[:key].eq("TORYO"))
          s = Membership.where(id: s.ids) # join をはずすことで 0.3 ms 速くなる
        end
      end
    end
  end
end

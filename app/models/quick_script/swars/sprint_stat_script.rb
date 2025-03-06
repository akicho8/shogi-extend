module QuickScript
  module Swars
    class SprintStatScript < Base
      self.title = "スプリントの先後勝率"
      self.description = "将棋ウォーズのスプリントの先後勝率を調べる"

      def call
        rows = [
          {
            "▲勝率" => ratio_by(:black).try { "%.3f %%" % (self * 100) },
            "△勝率" => ratio_by(:white).try { "%.3f %%" % (self * 100) },
            "▲勝数" => count_by(:black),
            "△勝数" => count_by(:white),
            "分母"   => denominator,
          },
        ]
        simple_table(rows, always_table: true)
      end

      private

      def count_by(location_key)
        counts_hash[[location_key, :win]] || 0
      end

      def ratio_by(location_key)
        denominator = count_by(:black) + count_by(:white)
        if denominator.positive?
          count = count_by(location_key)
          count.fdiv(denominator)
        end
      end

      def denominator
        count_by(:black) + count_by(:white)
      end

      def counts_hash
        @counts_hash ||= yield_self do
          Rails.cache.fetch([self.class.name, __method__].join("/"), :expires_in => Rails.env.local? ? 0.days : 1.days) do
            s = ::Swars::Membership.all
            s = s.joins(:battle)
            s = s.merge(::Swars::Battle.imode_eq(:sprint))
            s = s.joins(:location)
            s = s.joins(:judge)
            s = s.group("locations.key")
            s = s.group("judges.key")
            s.count.transform_keys { |e| e.collect(&:to_sym) }
          end
        end
      end
    end
  end
end

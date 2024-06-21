# frozen-string-literal: true

module Swars
  module User::Stat
    class PieceStat < Base
      class << self
        def report(options = {})
          options = {
            :user_keys  => User::Vip.auto_crawl_user_keys,
            :sample_max => 500,
          }.merge(options)

          options[:user_keys].collect { |user_key|
            if user = User[user_key]
              stat = user.stat(options)
              if stat.ids_count >= 100
                piece_stat = stat.piece_stat
                {
                  :user_key => user.key,
                  **piece_stat.to_report_h,
                }
              end
            end
          }.compact.sort_by { |e| e["最小率"] }
        end
      end

      delegate *[
        :ids_scope,
      ], to: :stat

      def to_chart
        @to_chart ||= FreqPieceInfo.collect do |e|
          { name: e.name, value: ratio_of(e.two_char_key) }
        end
      end

      def ratios_hash
        @ratios_hash ||= to_chart.each_with_object({}) { |e, h| h.update(e[:name].to_sym => e[:value]) }
      end

      def to_report_h
        hv = {}
        if e = to_chart.min_by { |e| e[:value] }
          hv["最小駒"] = e[:name]
          hv["最小率"] = "%.5f" % e[:value]
        end
        hv.update(ratios_hash.transform_values { |e| "%.5f" % e })
        hv
      end

      def ratio_of(key)
        if denominator.positive?
          counts_hash[key].fdiv(denominator)
        else
          0.0
        end
      end

      def denominator
        @denominator ||= counts_hash.values.sum
      end

      # membership.membership_extra.used_piece_counts # => {"B0"=>7, "G0"=>4, "K0"=>6, ... }
      # となっているので memberships ぶんだけ加算したハッシュを作る
      def counts_hash
        @counts_hash ||= yield_self do
          h = Hash.new(0)
          s = ids_scope
          s = s.preload(:membership_extra)
          s.each do |e|
            if e = e.membership_extra
              h.update(e.used_piece_counts) { |_, a, b| a + b } # MySQL で hash を合体できれば置き換える
            end
          end
          h
        end
      end
    end
  end
end

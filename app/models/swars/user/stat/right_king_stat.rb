# frozen-string-literal: true

module Swars
  module User::Stat
    class RightKingStat < Base
      delegate *[
        :tag_stat,
        :ids_count,
      ], to: :@stat

      def to_ratio_chart
        if count.positive?
          [
            { name: "右玉",   value: count             },
            { name: "その他", value: ids_count - count },
          ]
        end
      end

      def to_names_chart
        list = keys.find_all { |e| tag_stat.counts_hash.has_key?(e) }
        if list.present?
          list.collect { |e|
            { name: e, value: tag_stat.counts_hash[e] }
          }.sort_by { |e| -e[:value] }
        end
      end

      # 右玉形を使った回数
      def count
        @count ||= keys.sum { |e| tag_stat.counts_hash.fetch(e, 0) }
      end

      # 右玉形の戦法名一覧
      def keys
        @keys ||= Bioshogi::Explain::GroupInfo.fetch("右玉").values.collect(&:key)
      end
    end
  end
end

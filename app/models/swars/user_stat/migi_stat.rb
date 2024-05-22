# frozen-string-literal: true

module Swars
  module UserStat
    class MigiStat < Base
      delegate *[
        :all_tag,
        :ids_count,
      ], to: :@user_stat

      def to_ratio_chart
        if count.positive?
          [
            { name: "右玉",   value: count             },
            { name: "その他", value: ids_count - count },
          ]
        end
      end

      def to_names_chart
        list = keys.find_all { |e| all_tag.exist?(e) }
        if list.present?
          list.collect { |e|
            { name: e, value: all_tag.count(e) }
          }.sort_by { |e| -e[:value] }
        end
      end

      # 右玉形を使った回数
      def count
        @count ||= keys.sum { |e| all_tag.count(e) }
      end

      # 右玉形の戦法名一覧
      def keys
        @keys ||= Bioshogi::Explain::GroupInfo.fetch("右玉").values.collect(&:key)
      end
    end
  end
end

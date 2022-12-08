module Swars
  class UserInfo
    class MajorTacticTiltLevel
      def initialize(user_info)
        @user_info = user_info
      end

      def aggregate
        if tags.count > 0
          counts_hash = Hash.new(0)
          tags.each do |e|
            counts_hash[major_or_minor(e)] += e.count
          end
          ["王道", "マイナー"].collect do |e|
            { name: e, value: counts_hash[e] }
          end
        end
      end

      private

      def major_or_minor(tag)
        key = "王道"
        if e = Bioshogi::Explain::TacticInfo.flat_lookup(tag.name)
          if e = e.distribution_ratio
            if e.fetch(:rarity_diff) < 0
              key = "マイナー"
            end
          end
        end
        key
      end

      def tags
        @tags ||= yield_self do
          tags = [:attack_tags, :defense_tags].flat_map do |e|
            @user_info.ids_scope.tag_counts_on(e, at_least: @user_info.at_least_value)
          end
          tags = tags.reject { |e| e.name == "居玉" }
        end
      end
    end
  end
end

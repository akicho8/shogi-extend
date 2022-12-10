module Swars
  class UserInfo
    class RarityRatio
      OPTIMIZE = true

      def initialize(user_info)
        @user_info = user_info
      end

      def aggregate
        RarityInfo.reverse_each.collect do |e|
          { name: e.name_in_player_info, value: counts_hash[e.key] }
        end
      end

      def counts_hash
        @counts_hash ||= yield_self do
          hv = Hash.new(0)
          tags.each do |e|
            if key = rarity_key_of(e)
              hv[key] += e.count
            end
          end
          hv
        end
      end

      private

      def rarity_key_of(tag)
        if e = Bioshogi::Explain::TacticInfo.flat_lookup(tag.name)
          if e = e.distribution_ratio
            if OPTIMIZE
              # O(1)
              e.fetch(:rarity_key).to_sym
            else
              # O(n)
              emission_ratio = e.fetch(:emission_ratio)
              rarity_info = RarityInfo.find { |e| emission_ratio <= e.ratio } or raise "must not happen"
              rarity_info.key
            end
          end
        end
      end

      def tags
        @tags ||= [:attack_tags, :defense_tags].flat_map do |e|
          @user_info.ids_scope.tag_counts_on(e, at_least: @user_info.at_least_value)
        end
      end
    end
  end
end

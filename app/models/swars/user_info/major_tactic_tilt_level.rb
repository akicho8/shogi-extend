module Swars
  class UserInfo
    class MajorTacticTiltLevel
      def initialize(user_info)
        @user_info = user_info
      end

      def aggregate
        tags = [:attack_tags, :defense_tags].flat_map do |e|
          @user_info.ids_scope.tag_counts_on(e, at_least: @user_info.at_least_value)
        end
        if tags.count > 0
          total = tags.sum { |tag|
            level = 0
            if tag.name != "居玉"
              if e = Bioshogi::Explain::TacticInfo.flat_lookup(tag.name)
                if e = e.distribution_ratio
                  level = e.fetch(:rarity_diff) * tag.count
                end
              end
            end
            level
          }
          total.fdiv(tags.count)
        end
      end
    end
  end
end

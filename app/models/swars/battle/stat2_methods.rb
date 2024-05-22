module Swars
  class Battle
    concern :Stat2Methods do
      included do
        CRITICAL_TURN_AVG = 21.8606
        OUTBREAK_TURN_AVG = 42.0553
        TURN_MAX_AVG      = 89.4866
      end

      class_methods do
        def stat2
          {}.tap do |hv|
            scope = where(arel_table[:turn_max].gteq(14))
            hv[:critical_turn] = scope.average(:critical_turn).to_f # => 21.8606
            hv[:outbreak_turn] = scope.average(:outbreak_turn).to_f # => 42.0553
            hv[:turn_max]      = scope.average(:turn_max).to_f      # => 89.4866
          end
        end
      end
    end
  end
end

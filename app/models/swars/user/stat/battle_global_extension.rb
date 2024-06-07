# frozen-string-literal: true

module Swars
  module User::Stat
    concern :BattleGlobalExtension do
      included do
        scope :turn_max_eq, -> n { where(turn_max: n) }
      end
    end
  end
end

module Swars
  class Battle
    concern :SearchMethods do
      included do
        scope :search, -> params { Search.new(all, params).perform }
      end
    end
  end
end

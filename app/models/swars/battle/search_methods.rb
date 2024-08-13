module Swars
  class Battle
    concern :SearchMethods do
      included do
        scope :find_all_by_params, -> (params = {}) { Search.new(params.merge(all: all)).call }
        scope :find_all_by_query,  -> (query = "", params = {}) { find_all_by_params(params.merge(query: query)) }
      end
    end
  end
end

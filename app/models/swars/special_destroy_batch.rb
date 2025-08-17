# Swars::SpecialDestroyBatch.call(name: "特別", process_loop_max: 1)

module Swars
  class SpecialDestroyBatch < BatchTask::Base
    include BatchTask::CollectionType

    def collection
      Swars::Battle.in_batches
    end

    def process(scope)
      destroy_scope(scope.destroyable_s)
    end
  end
end

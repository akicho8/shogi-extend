# Swars::NormalDestroyBatch.call(name: "一般", process_loop_max: 1)

module Swars
  class NormalDestroyBatch < BatchTask::Base
    include BatchTask::CollectionType

    def collection
      Swars::Battle.in_batches
    end

    def process(scope)
      destroy_scope(scope.destroyable_n)
    end
  end
end

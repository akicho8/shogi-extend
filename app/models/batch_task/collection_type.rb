module BatchTask
  module CollectionType
    def call
      measure_block do
        collection.each.with_index do |scope, i|
          if v = params[:process_loop_max]
            if i >= v
              break
            end
          end
          process(scope)
        end
      end
    end

    def collection
      # Swars::Battle.in_batches
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def process(scope)
      # scope.destroyable_n.each do |e|
      #   destroy_process(e)
      # end
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def destroy_scope(scope)
      scope.each do |record|
        destroy_process(record)
      end
    end

    def destroy_process(record)
      begin
        Retryable.retryable(on: ActiveRecord::Deadlocked, tries: 10, sleep: 1) do
          if execute?
            record.destroy!
          end
          if verbose?
            puts "#{record.class.name} #{record.id} destroyed"
          end
        end
      rescue => error
        RorVsWild.record_error(error)
      end
    end
  end
end

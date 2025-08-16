# frozen_string_literal: true

module Maintenance
  class NoCollectionTask < MaintenanceTasks::Task
    no_collection

    def process
      # The work to be done
    end
  end
end

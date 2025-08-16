# frozen_string_literal: true

module Maintenance
  class MyTask < MaintenanceTasks::Task
    attribute :before_date, :date
    attribute :title, :string
    validates :title, presence: true

    def collection
      Swars::Battle.in_batches
    end

    def process(scope)
      p scope.size
    end

    def count
      # Optionally, define the number of rows that will be iterated over
      # This is used to track the task's progress
    end
  end
end

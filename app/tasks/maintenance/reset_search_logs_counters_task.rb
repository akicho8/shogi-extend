module Maintenance
  class ResetSearchLogsCountersTask < MaintenanceTasks::Task
    def collection
      Swars::User.find_each
    end

    def process(user)
      Swars::User.reset_counters(user.id, :search_logs)
    end
  end
end

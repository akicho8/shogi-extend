require "./setup"
# GoogleApi::ExpirationTracker.delete_all
facade = GoogleApi::Facade.new(rows: [{ id: 1 }])
facade.rows               # => [[:id], [1]]
facade.call               # => "https://docs.google.com/spreadsheets/d/1ahucSBfBIS5TEXaO1ejd64qC1bvAsdWzwNeQ4N8YM_A/edit"
# GoogleApi::ExpirationTracker.find_each do |e|
#   e.spreadsheet_delete rescue puts $!
# end
tp GoogleApi::ExpirationTracker
# >> |-----+----------------------------------------------+---------------------------+---------------------------|
# >> | id  | spreadsheet_id                               | created_at                | updated_at                |
# >> |-----+----------------------------------------------+---------------------------+---------------------------|
# >> | 141 | 1rbEKAnsO7Gy5mK40NTkWvhnrkhb3pfw6bPjVT9fCBws | 2025-08-02 13:08:40 +0900 | 2025-08-02 13:08:40 +0900 |
# >> | 142 | 1lgmX-OuQuMisvRwxVFkUGcn4egkY8yFHz3UU_JGo1LI | 2025-08-14 13:33:31 +0900 | 2025-08-14 13:33:31 +0900 |
# >> | 143 | 1ahucSBfBIS5TEXaO1ejd64qC1bvAsdWzwNeQ4N8YM_A | 2025-08-14 13:36:46 +0900 | 2025-08-14 13:36:46 +0900 |
# >> |-----+----------------------------------------------+---------------------------+---------------------------|

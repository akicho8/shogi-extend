require "./setup"
# GoogleApi::ExpirationTracker.delete_all
facade = GoogleApi::Facade.new(rows: [{id: 1}])
facade.rows               # => [[:id], [1]]
facade.call               # => "https://docs.google.com/spreadsheets/d/1fXVZWFvQ7ytkZiIyPK1GhTOlcmX_g-5gfhBr7OW-uOA/edit"
# GoogleApi::ExpirationTracker.find_each do |e|
#   e.spreadsheet_delete rescue puts $!
# end
tp GoogleApi::ExpirationTracker
# >> 2024-07-23T06:32:45.008Z pid=1444 tid=3rs INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |----+----------------------------------------------+---------------------------+---------------------------|
# >> | id | spreadsheet_id                               | created_at                | updated_at                |
# >> |----+----------------------------------------------+---------------------------+---------------------------|
# >> | 58 | 1fXVZWFvQ7ytkZiIyPK1GhTOlcmX_g-5gfhBr7OW-uOA | 2024-07-23 15:32:45 +0900 | 2024-07-23 15:32:45 +0900 |
# >> |----+----------------------------------------------+---------------------------+---------------------------|

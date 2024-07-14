require "./setup"
# GoogleApi::ExpirationTracker.delete_all
# GoogleApi::Facade.new(source_rows: [{id: 1}]).call # => "https://docs.google.com/spreadsheets/d/1q7wSEZFzHJ6zsBYMH5HqYR_qKXIphBbjkTL0aOf1SpU/edit"
# tp GoogleApi::ExpirationTracker
# # expiration_tracker = GoogleApi::ExpirationTracker.create!(spreadsheet_id: SecureRandom.hex) # => #<GoogleApi::ExpirationTracker id: 15, spreadsheet_id: "d2356a1d581d3a42914a6c59a0e6281b", created_at: "2024-07-13 20:42:06.002323000 +0900", updated_at: "2024-07-13 20:42:06.002323000 +0900">
# sql
# GoogleApi::ExpirationTracker.last.destroy!
# tp GoogleApi::ExpirationTracker

tp GoogleApi::ExpirationTracker
GoogleApi::ExpirationTracker.destroy_all

# >> |----+----------------------------------------------+---------------------------+---------------------------|
# >> | id | spreadsheet_id                               | created_at                | updated_at                |
# >> |----+----------------------------------------------+---------------------------+---------------------------|
# >> | 19 | 1EIJDOwq5g26XIDv-hzN7ft--_oHdhM2jVMQUUGDhozk | 2024-07-13 22:20:05 +0900 | 2024-07-13 22:20:05 +0900 |
# >> |----+----------------------------------------------+---------------------------+---------------------------|

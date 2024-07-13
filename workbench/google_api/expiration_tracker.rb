require "./setup"
GoogleApi::ExpirationTracker.delete_all
GoogleApi::Facade.new(source_rows: [{id: 1}]).call # => "https://docs.google.com/spreadsheets/d/1q7wSEZFzHJ6zsBYMH5HqYR_qKXIphBbjkTL0aOf1SpU/edit"
tp GoogleApi::ExpirationTracker
# expiration_tracker = GoogleApi::ExpirationTracker.create!(spreadsheet_id: SecureRandom.hex) # => #<GoogleApi::ExpirationTracker id: 15, spreadsheet_id: "d2356a1d581d3a42914a6c59a0e6281b", created_at: "2024-07-13 20:42:06.002323000 +0900", updated_at: "2024-07-13 20:42:06.002323000 +0900">
sql
GoogleApi::ExpirationTracker.last.destroy!
tp GoogleApi::ExpirationTracker

# >> |----+----------------------------------------------+---------------------------+---------------------------|
# >> | id | spreadsheet_id                               | created_at                | updated_at                |
# >> |----+----------------------------------------------+---------------------------+---------------------------|
# >> | 18 | 1q7wSEZFzHJ6zsBYMH5HqYR_qKXIphBbjkTL0aOf1SpU | 2024-07-13 20:43:09 +0900 | 2024-07-13 20:43:09 +0900 |
# >> |----+----------------------------------------------+---------------------------+---------------------------|
# >>   GoogleApi::ExpirationTracker Load (0.6ms)  SELECT `google_api_expiration_trackers`.* FROM `google_api_expiration_trackers` ORDER BY `google_api_expiration_trackers`.`id` DESC LIMIT 1
# >>   TRANSACTION (0.2ms)  BEGIN
# >>   GoogleApi::ExpirationTracker Destroy (0.5ms)  DELETE FROM `google_api_expiration_trackers` WHERE `google_api_expiration_trackers`.`id` = 18
# >>   AppLog Create (0.6ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('info', '', '[GoogleApi][spreadsheet_id][削除]', '1q7wSEZFzHJ6zsBYMH5HqYR_qKXIphBbjkTL0aOf1SpU', 60140, '2024-07-13 11:43:11')
# >>   ↳ app/models/app_log.rb:106:in `call'
# >> Spreadsheet with ID 1q7wSEZFzHJ6zsBYMH5HqYR_qKXIphBbjkTL0aOf1SpU deleted successfully.
# >>   TRANSACTION (1.5ms)  COMMIT
# >>   GoogleApi::ExpirationTracker Load (0.6ms)  SELECT `google_api_expiration_trackers`.* FROM `google_api_expiration_trackers`

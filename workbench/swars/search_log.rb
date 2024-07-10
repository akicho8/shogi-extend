require "./setup"
sql
Swars::SearchLog.old_only(50.days).cleaner.call
# Swars::User.find(257)           # => #<Swars::User id: 257, user_key: "ebitaro2", grade_id: 9, last_reception_at: nil, search_logs_count: 0, created_at: "2018-08-02 14:24:23.000000000 +0900", updated_at: "2023-11-29 02:44:41.000000000 +0900", ban_at: nil, latest_battled_at: "2018-08-02 14:24:23.000000000 +0900">
# .cleaner.call
# >>   Swars::SearchLog Count (0.8ms)  SELECT COUNT(*) FROM `swars_search_logs` WHERE `swars_search_logs`.`created_at` <= '2024-05-21 12:46:46'
# >>   ↳ app/models/general_cleaner.rb:15:in `call'
# >>   Swars::SearchLog Count (0.4ms)  SELECT COUNT(*) FROM `swars_search_logs` WHERE `swars_search_logs`.`created_at` <= '2024-05-21 12:46:46'
# >>   ↳ app/models/general_cleaner.rb:16:in `call'
# >>   TRANSACTION (0.2ms)  BEGIN
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   AppLog Create (1.4ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('trace', '', '', '[\"/Users/ikeda/src/shogi-extend/app/models/free_space.rb:22\", :call]', 95091, '2024-07-10 12:46:46')
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   TRANSACTION (1.8ms)  COMMIT
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   Swars::SearchLog Load (0.5ms)  SELECT `swars_search_logs`.* FROM `swars_search_logs` WHERE `swars_search_logs`.`created_at` <= '2024-05-21 12:46:46' ORDER BY `swars_search_logs`.`id` ASC LIMIT 1000
# >>   ↳ app/models/general_cleaner.rb:20:in `block in call'
# >>   Swars::SearchLog Count (1.1ms)  SELECT COUNT(*) FROM `swars_search_logs` WHERE `swars_search_logs`.`created_at` <= '2024-05-21 12:46:46'
# >>   ↳ app/models/general_cleaner.rb:30:in `call'
# >> 2024-07-10T12:46:46.335Z pid=95091 tid=1ydv INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >>   TRANSACTION (0.3ms)  BEGIN
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   AppLog Create (1.4ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('important', '', 'レコード削除 21個 58%→58%', '|------------+-------|\n|    subject |       |\n|    execute | false |\n| time_limit |       |\n|    verbose | false |\n| batch_size | 1000  |\n|------------+-------|\n|------+---------------------|\n|   前 | 21                  |\n|   後 | 21                  |\n|   差 | 0                   |\n| 開始 | 2024-07-10 21:46:46 |\n| 終了 | 2024-07-10 21:46:46 |\n| 空き | 58% → 58%          |\n|------+---------------------|\n|---------------------+------+------+------|\n| 日時                | 個数 | 成功 | 失敗 |\n|---------------------+------+------+------|\n| 2024-07-10 21:46:46 |   21 |   21 |    0 |\n|---------------------+------+------+------|\n', 95091, '2024-07-10 12:46:46')
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   TRANSACTION (1.0ms)  COMMIT
# >>   ↳ app/models/app_log.rb:106:in `call'

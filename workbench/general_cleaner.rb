require "./setup"
sql
GeneralCleaner.new(verbose: true, subject: "subject").call
# >>   TRANSACTION (0.3ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/app_log.rb:103:in 'AppLog.call'
# >>   AppLog Create (2.2ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('trace', '', '', '[\"/Users/ikeda/src/shogi/shogi-extend/app/models/free_space.rb:22\", :call]', 42898, '2025-07-28 10:46:22') /*application='ShogiWeb'*/
# >>   ↳ app/models/app_log.rb:103:in 'AppLog.call'
# >>   TRANSACTION (1.1ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/app_log.rb:103:in 'AppLog.call'
# >>
# >> 2025-07-28T10:46:22.130Z pid=42898 tid=yg2 INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >>   TRANSACTION (0.4ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/app_log.rb:103:in 'AppLog.call'
# >>   AppLog Create (3.5ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('important', '', '[レコード削除] [subject] 0 → 0 (0) 0.098742 seconds', '|------------+---------|\n|    subject | subject |\n|    execute | false   |\n| time_limit |         |\n|    verbose | true    |\n| batch_size | 1000    |\n|------------+---------|\n|------+---------------------|\n|   前 | 0                   |\n|   後 | 0                   |\n|   差 | 0                   |\n| 開始 | 2025-07-28 19:46:22 |\n| 終了 | 2025-07-28 19:46:22 |\n| 時間 | 0.098742 seconds    |\n| 空き | 57% → 57%          |\n|------+---------------------|\n|---------------------+------+------+------|\n| 日時                | 個数 | 成功 | 失敗 |\n|---------------------+------+------+------|\n| 2025-07-28 19:46:22 |    0 |    0 |    0 |\n|---------------------+------+------+------|\n', 42898, '2025-07-28 10:46:22') /*application='ShogiWeb'*/
# >>   ↳ app/models/app_log.rb:103:in 'AppLog.call'
# >>   TRANSACTION (1.8ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/app_log.rb:103:in 'AppLog.call'
# >> [レコード削除] [subject] 0 → 0 (0) 0.098742 seconds
# >> |------------+---------|
# >> |    subject | subject |
# >> |    execute | false   |
# >> | time_limit |         |
# >> |    verbose | true    |
# >> | batch_size | 1000    |
# >> |------------+---------|
# >> |------+---------------------|
# >> |   前 | 0                   |
# >> |   後 | 0                   |
# >> |   差 | 0                   |
# >> | 開始 | 2025-07-28 19:46:22 |
# >> | 終了 | 2025-07-28 19:46:22 |
# >> | 時間 | 0.098742 seconds    |
# >> | 空き | 57% → 57%          |
# >> |------+---------------------|
# >> |---------------------+------+------+------|
# >> | 日時                | 個数 | 成功 | 失敗 |
# >> |---------------------+------+------+------|
# >> | 2025-07-28 19:46:22 |    0 |    0 |    0 |
# >> |---------------------+------+------+------|

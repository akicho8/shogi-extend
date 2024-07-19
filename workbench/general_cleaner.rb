require "./setup"
sql
GeneralCleaner.new(verbose: true, subject: "subject").call
# >>   TRANSACTION (0.3ms)  BEGIN
# >>   ↳ app/models/app_log.rb:102:in `call'
# >>   AppLog Create (1.4ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('trace', '', '', '[\"/Users/ikeda/src/shogi-extend/app/models/free_space.rb:22\", :call]', 6606, '2024-07-19 02:49:38')
# >>   ↳ app/models/app_log.rb:102:in `call'
# >>   TRANSACTION (1.0ms)  COMMIT
# >>   ↳ app/models/app_log.rb:102:in `call'
# >> 2024-07-19T02:49:38.355Z pid=6606 tid=31u INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >>   TRANSACTION (0.5ms)  BEGIN
# >>   ↳ app/models/app_log.rb:102:in `call'
# >>   AppLog Create (1.7ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('important', '', '[レコード削除] [subject] 0 → 0 (0) 0.066396 seconds', '|------------+---------|\n|    subject | subject |\n|    execute | false   |\n| time_limit |         |\n|    verbose | true    |\n| batch_size | 1000    |\n|------------+---------|\n|------+---------------------|\n|   前 | 0                   |\n|   後 | 0                   |\n|   差 | 0                   |\n| 開始 | 2024-07-19 11:49:38 |\n| 終了 | 2024-07-19 11:49:38 |\n| 時間 | 0.066396 seconds    |\n| 空き | 58% → 58%          |\n|------+---------------------|\n|---------------------+------+------+------|\n| 日時                | 個数 | 成功 | 失敗 |\n|---------------------+------+------+------|\n| 2024-07-19 11:49:38 |    0 |    0 |    0 |\n|---------------------+------+------+------|\n', 6606, '2024-07-19 02:49:38')
# >>   ↳ app/models/app_log.rb:102:in `call'
# >>   TRANSACTION (1.4ms)  COMMIT
# >>   ↳ app/models/app_log.rb:102:in `call'
# >> [レコード削除] [subject] 0 → 0 (0) 0.066396 seconds
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
# >> | 開始 | 2024-07-19 11:49:38 |
# >> | 終了 | 2024-07-19 11:49:38 |
# >> | 時間 | 0.066396 seconds    |
# >> | 空き | 58% → 58%          |
# >> |------+---------------------|
# >> |---------------------+------+------+------|
# >> | 日時                | 個数 | 成功 | 失敗 |
# >> |---------------------+------+------+------|
# >> | 2024-07-19 11:49:38 |    0 |    0 |    0 |
# >> |---------------------+------+------+------|

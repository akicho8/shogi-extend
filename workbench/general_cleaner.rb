require "./setup"
sql
GeneralCleaner.new(verbose: true).call
# >>   TRANSACTION (0.5ms)  BEGIN
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   AppLog Create (1.6ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('trace', '', '', '[\"/Users/ikeda/src/shogi-extend/app/models/free_space.rb:22\", :call]', 86966, '2024-06-08 08:15:37')
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   TRANSACTION (1.2ms)  COMMIT
# >>   ↳ app/models/app_log.rb:106:in `call'
# >> 2024-06-08T08:15:38.063Z pid=86966 tid=1sem INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >>   TRANSACTION (0.4ms)  BEGIN
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   AppLog Create (1.8ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('important', '', 'レコード削除 0個 47%→47%', '|------------+-------|\n|    subject |       |\n|    execute | false |\n| time_limit |       |\n|    verbose | true  |\n|------------+-------|\n|------+---------------------|\n|   前 | 0                   |\n|   後 | 0                   |\n|   差 | 0                   |\n| 開始 | 2024-06-08 17:15:37 |\n| 終了 | 2024-06-08 17:15:38 |\n| 空き | 47% → 47%          |\n|------+---------------------|\n|---------------------+------+------+------|\n| 日時                | 個数 | 成功 | 失敗 |\n|---------------------+------+------+------|\n| 2024-06-08 17:15:38 |    0 |    0 |    0 |\n|---------------------+------+------+------|\n', 86966, '2024-06-08 08:15:38')
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   TRANSACTION (1.0ms)  COMMIT
# >>   ↳ app/models/app_log.rb:106:in `call'
# >> レコード削除 0個 47%→47%
# >> |------------+-------|
# >> |    subject |       |
# >> |    execute | false |
# >> | time_limit |       |
# >> |    verbose | true  |
# >> |------------+-------|
# >> |------+---------------------|
# >> |   前 | 0                   |
# >> |   後 | 0                   |
# >> |   差 | 0                   |
# >> | 開始 | 2024-06-08 17:15:37 |
# >> | 終了 | 2024-06-08 17:15:38 |
# >> | 空き | 47% → 47%          |
# >> |------+---------------------|
# >> |---------------------+------+------+------|
# >> | 日時                | 個数 | 成功 | 失敗 |
# >> |---------------------+------+------+------|
# >> | 2024-06-08 17:15:38 |    0 |    0 |    0 |
# >> |---------------------+------+------+------|

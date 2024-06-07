require "./setup"
sql
Swars::Battle::Cleanup.new(verbose: true).call
# >>   TRANSACTION (0.7ms)  BEGIN
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   AppLog Create (2.4ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('trace', '', '', '[\"/Users/ikeda/src/shogi-extend/app/models/free_space.rb:22\", :call]', 52393, '2024-06-06 11:51:39')
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   TRANSACTION (1.3ms)  COMMIT
# >>   ↳ app/models/app_log.rb:106:in `call'
# >> 2024-06-06T11:51:39.166Z pid=52393 tid=16vl INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >>   TRANSACTION (0.5ms)  BEGIN
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   AppLog Create (2.7ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('important', '', 'バトル削除 0個 49%→49%', '|------------+-------|\n|    execute | false |\n| time_limit |       |\n|    verbose | true  |\n|------------+-------|\n|------+---------------------|\n|   前 | 0                   |\n|   後 | 0                   |\n|   差 | 0                   |\n| 開始 | 2024-06-06 20:51:38 |\n| 終了 | 2024-06-06 20:51:39 |\n| 空き | 49% → 49%          |\n|------+---------------------|\n', 52393, '2024-06-06 11:51:39')
# >>   ↳ app/models/app_log.rb:106:in `call'
# >>   TRANSACTION (0.8ms)  COMMIT
# >>   ↳ app/models/app_log.rb:106:in `call'
# >> バトル削除 0個 49%→49%
# >> |------------+-------|
# >> |    execute | false |
# >> | time_limit |       |
# >> |    verbose | true  |
# >> |------------+-------|
# >> |------+---------------------|
# >> |   前 | 0                   |
# >> |   後 | 0                   |
# >> |   差 | 0                   |
# >> | 開始 | 2024-06-06 20:51:38 |
# >> | 終了 | 2024-06-06 20:51:39 |
# >> | 空き | 49% → 49%          |
# >> |------+---------------------|

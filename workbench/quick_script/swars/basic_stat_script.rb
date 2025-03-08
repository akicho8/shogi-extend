require "./setup"
object = QuickScript::Swars::BasicStatScript.new
object.cache_all
tp object.sprintha_gotegatuyoi_noka.call
# >> 2025-03-07T12:22:45.689Z pid=27524 tid=ork INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |----------+----------+--------+--------+-------|
# >> | ▲勝率   | △勝率   | ▲勝数 | △勝数 | 分母  |
# >> |----------+----------+--------+--------+-------|
# >> | 46.367 % | 53.633 % |  30183 |  34913 | 65096 |
# >> |----------+----------+--------+--------+-------|

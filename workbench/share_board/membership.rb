require "#{__dir__}/setup"
ShareBoard::Room.mock
room = ShareBoard::Room.first               # => #<ShareBoard::Room id: 1, key: "dev_room1", battles_count: 1, created_at: "2026-05-02 07:57:34.000000000 +0900", updated_at: "2026-05-02 07:57:34.000000000 +0900", chat_messages_count: 0, name: "共有将棋盤">
user = ShareBoard::Roomship.first.user             # => #<ShareBoard::User id: 1, name: "a", memberships_count: 3, created_at: "2026-05-02 07:57:34.000000000 +0900", updated_at: "2026-05-02 23:58:48.000000000 +0900", chat_messages_count: 0>

s = room.memberships
s = s.joins(:judge)
s = s.where(user: user)
s = s.group("judges.key")
s.count                         # => 

# ~> /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/trilogy/database_statements.rb:27:in 'Trilogy#query': Trilogy::ProtocolError: 1055: Expression #1 of ORDER BY clause is not in GROUP BY clause and contains nonaggregated column 'shogi_web_development.share_board_memberships.position' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by (trilogy_query_recv) (ActiveRecord::StatementInvalid)
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/trilogy/database_statements.rb:27:in 'ActiveRecord::ConnectionAdapters::Trilogy::DatabaseStatements#perform_query'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:571:in 'block (2 levels) in ActiveRecord::ConnectionAdapters::DatabaseStatements#raw_execute'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract_adapter.rb:1086:in 'block in ActiveRecord::ConnectionAdapters::AbstractAdapter#with_raw_connection'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activesupport-8.1.2/lib/active_support/concurrency/null_lock.rb:9:in 'ActiveSupport::Concurrency::NullLock#synchronize'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract_adapter.rb:1055:in 'ActiveRecord::ConnectionAdapters::AbstractAdapter#with_raw_connection'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:570:in 'block in ActiveRecord::ConnectionAdapters::DatabaseStatements#raw_execute'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activesupport-8.1.2/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract_adapter.rb:1206:in 'ActiveRecord::ConnectionAdapters::AbstractAdapter#log'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:569:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#raw_execute'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:613:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#internal_execute'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:555:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#internal_exec_query'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:708:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#select'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:76:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#select_all'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/query_cache.rb:278:in 'ActiveRecord::ConnectionAdapters::QueryCache#select_all'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:570:in 'block (2 levels) in ActiveRecord::Calculations#execute_grouped_calculation'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation.rb:1494:in 'ActiveRecord::Relation#skip_query_cache_if_necessary'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:569:in 'block in ActiveRecord::Calculations#execute_grouped_calculation'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/connection_pool.rb:457:in 'ActiveRecord::ConnectionAdapters::ConnectionPool#with_connection'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_handling.rb:313:in 'ActiveRecord::ConnectionHandling#with_connection'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:540:in 'ActiveRecord::Calculations#execute_grouped_calculation'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:459:in 'ActiveRecord::Calculations#perform_calculation'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:244:in 'ActiveRecord::Calculations#calculate'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:102:in 'ActiveRecord::Calculations#count'
# ~> 	from -:10:in '<main>'
# ~> /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/trilogy/database_statements.rb:27:in 'Trilogy#query': 1055: Expression #1 of ORDER BY clause is not in GROUP BY clause and contains nonaggregated column 'shogi_web_development.share_board_memberships.position' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by (trilogy_query_recv) (Trilogy::ProtocolError)
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/trilogy/database_statements.rb:27:in 'ActiveRecord::ConnectionAdapters::Trilogy::DatabaseStatements#perform_query'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:571:in 'block (2 levels) in ActiveRecord::ConnectionAdapters::DatabaseStatements#raw_execute'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract_adapter.rb:1086:in 'block in ActiveRecord::ConnectionAdapters::AbstractAdapter#with_raw_connection'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activesupport-8.1.2/lib/active_support/concurrency/null_lock.rb:9:in 'ActiveSupport::Concurrency::NullLock#synchronize'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract_adapter.rb:1055:in 'ActiveRecord::ConnectionAdapters::AbstractAdapter#with_raw_connection'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:570:in 'block in ActiveRecord::ConnectionAdapters::DatabaseStatements#raw_execute'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activesupport-8.1.2/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract_adapter.rb:1206:in 'ActiveRecord::ConnectionAdapters::AbstractAdapter#log'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:569:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#raw_execute'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:613:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#internal_execute'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:555:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#internal_exec_query'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:708:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#select'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/database_statements.rb:76:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#select_all'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/query_cache.rb:278:in 'ActiveRecord::ConnectionAdapters::QueryCache#select_all'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:570:in 'block (2 levels) in ActiveRecord::Calculations#execute_grouped_calculation'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation.rb:1494:in 'ActiveRecord::Relation#skip_query_cache_if_necessary'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:569:in 'block in ActiveRecord::Calculations#execute_grouped_calculation'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_adapters/abstract/connection_pool.rb:457:in 'ActiveRecord::ConnectionAdapters::ConnectionPool#with_connection'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/connection_handling.rb:313:in 'ActiveRecord::ConnectionHandling#with_connection'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:540:in 'ActiveRecord::Calculations#execute_grouped_calculation'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:459:in 'ActiveRecord::Calculations#perform_calculation'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:244:in 'ActiveRecord::Calculations#calculate'
# ~> 	from /opt/rbenv/versions/4.0.2/lib/ruby/gems/4.0.0/gems/activerecord-8.1.2/lib/active_record/relation/calculations.rb:102:in 'ActiveRecord::Calculations#count'
# ~> 	from -:10:in '<main>'

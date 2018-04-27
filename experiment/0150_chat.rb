#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ChatArticle.destroy_all
ChatUser.destroy_all
ChatRoom.destroy_all
ChatMembership.destroy_all

alice = ChatUser.create!
bob = ChatUser.create!

chat_room = alice.owner_rooms.create!
chat_room.chat_users << alice
chat_room.chat_users << bob

tp chat_room.chat_memberships

alice.chat_articles.create(chat_room: chat_room, message: "(body)")
tp ChatArticle

tp chat_room

# ~> /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/mysql2-0.5.1/lib/mysql2/client.rb:131:in `_query': Mysql2::Error: Field 'kifu_body_sfen' doesn't have a default value: INSERT INTO `chat_rooms` (`room_owner_id`, `preset_key`, `name`, `created_at`, `updated_at`) VALUES (41, '平手', '野良1号の対戦部屋 #1', '2018-04-27 09:24:21', '2018-04-27 09:24:21') (ActiveRecord::NotNullViolation)
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/mysql2-0.5.1/lib/mysql2/client.rb:131:in `block in query'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/mysql2-0.5.1/lib/mysql2/client.rb:130:in `handle_interrupt'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/mysql2-0.5.1/lib/mysql2/client.rb:130:in `query'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract_mysql_adapter.rb:214:in `block (2 levels) in execute'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.6/lib/active_support/dependencies/interlock.rb:46:in `block in permit_concurrent_loads'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.6/lib/active_support/concurrency/share_lock.rb:185:in `yield_shares'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.6/lib/active_support/dependencies/interlock.rb:45:in `permit_concurrent_loads'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract_mysql_adapter.rb:213:in `block in execute'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract_adapter.rb:613:in `block (2 levels) in log'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/2.5.0/monitor.rb:226:in `mon_synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract_adapter.rb:612:in `block in log'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.6/lib/active_support/notifications/instrumenter.rb:21:in `instrument'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract_adapter.rb:604:in `log'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract_mysql_adapter.rb:212:in `execute'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/mysql/database_statements.rb:26:in `execute'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract_mysql_adapter.rb:223:in `execute_and_free'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/mysql/database_statements.rb:31:in `exec_query'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract/database_statements.rb:102:in `exec_insert'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract/database_statements.rb:133:in `insert'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract/query_cache.rb:17:in `insert'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/relation.rb:61:in `insert'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/persistence.rb:582:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/counter_cache.rb:178:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/locking/optimistic.rb:69:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/attribute_methods/dirty.rb:297:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/callbacks.rb:340:in `block in _create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.6/lib/active_support/callbacks.rb:131:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.6/lib/active_support/callbacks.rb:827:in `_run_create_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/callbacks.rb:340:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/timestamp.rb:95:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/persistence.rb:553:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/callbacks.rb:336:in `block in create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.6/lib/active_support/callbacks.rb:131:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.6/lib/active_support/callbacks.rb:827:in `_run_save_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/callbacks.rb:336:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/persistence.rb:162:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/validations.rb:50:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/attribute_methods/dirty.rb:43:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/transactions.rb:313:in `block in save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/transactions.rb:384:in `block in with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract/database_statements.rb:233:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/transactions.rb:210:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/transactions.rb:381:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/transactions.rb:313:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/suppressor.rb:46:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/collection_association.rb:369:in `insert_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/has_many_association.rb:34:in `insert_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/collection_association.rb:360:in `block (2 levels) in _create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/collection_association.rb:447:in `replace_on_target'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/collection_association.rb:281:in `add_to_target'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/collection_association.rb:358:in `block in _create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/collection_association.rb:129:in `block in transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract/database_statements.rb:235:in `block in transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract/transaction.rb:194:in `block in within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/2.5.0/monitor.rb:226:in `mon_synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract/transaction.rb:191:in `within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/connection_adapters/abstract/database_statements.rb:235:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/transactions.rb:210:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/collection_association.rb:128:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/collection_association.rb:357:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/has_many_association.rb:121:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/association.rb:200:in `create!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.6/lib/active_record/associations/collection_proxy.rb:363:in `create!'
# ~> 	from -:12:in `<main>'

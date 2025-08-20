require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "XA", result_key: "維持" })
Ppl::Updater.update_raw(6, { name: "BX", result_key: "維持" })
Ppl::User.plus_minus_search("A -B").collect(&:name) == ["XA"] # => 
exit

Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "XA", result_key: "維持" })
Ppl::Updater.update_raw(6, { name: "BX", result_key: "維持" })
Ppl::User.plus_minus_search("A -B").collect(&:name) == ["XA"] # => 

Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "alice", result_key: "維持", age: 1, win: 3 })
Ppl::Updater.update_raw(6, { name: "alice", result_key: "次点", age: 2, win: 2 })
Ppl::Updater.update_raw(7, { name: "alice", result_key: "昇段", age: 3, win: 1 })
user = Ppl::User["alice"]
user.age_min                                # => 
user.age_max                                # => 
user.runner_up_count                        # => 
user.win_max                                # => 
user.promotion_membership.league_season.season_number # => 
user.promotion_season_number                   # => 
user.promotion_win                          # => 
user.memberships_first.league_season.season_number       # => 
user.memberships_last.league_season.season_number       # => 
user.season_number_min                         # => 
user.season_number_max                         # => 
tp Ppl::LeagueSeason
tp Ppl::User
tp Ppl::Membership
# ~> /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activemodel-8.0.2.1/lib/active_model/attribute_methods.rb:512:in 'ActiveModel::AttributeMethods#method_missing': undefined method 'rank_id' for an instance of Ppl::User (NoMethodError)
# ~> Did you mean?  rank
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/attribute_methods.rb:495:in 'ActiveRecord::AttributeMethods#method_missing'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/application_record.rb:34:in 'Kernel#public_send'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/application_record.rb:34:in 'block in ApplicationRecord.custom_belongs_to'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:406:in 'BasicObject#instance_exec'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:406:in 'block in ActiveSupport::Callbacks::CallTemplate::InstanceExec0#make_lambda'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:178:in 'block in ActiveSupport::Callbacks::Filters::Before#call'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:668:in 'block (2 levels) in ActiveSupport::Callbacks::CallbackChain#default_terminator'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:667:in 'Kernel#catch'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:667:in 'block in ActiveSupport::Callbacks::CallbackChain#default_terminator'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:179:in 'ActiveSupport::Callbacks::Filters::Before#call'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:559:in 'block in ActiveSupport::Callbacks::CallbackSequence#invoke_before'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:559:in 'Array#each'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:559:in 'ActiveSupport::Callbacks::CallbackSequence#invoke_before'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:108:in 'ActiveSupport::Callbacks#run_callbacks'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/callbacks.rb:913:in 'ActiveRecord::Base#_run_validation_callbacks'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activemodel-8.0.2.1/lib/active_model/validations/callbacks.rb:115:in 'ActiveModel::Validations::Callbacks#run_validations!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activemodel-8.0.2.1/lib/active_model/validations.rb:365:in 'ActiveModel::Validations#valid?'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/validations.rb:71:in 'ActiveRecord::Validations#valid?'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/validations.rb:91:in 'ActiveRecord::Validations#perform_validations'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/validations.rb:54:in 'ActiveRecord::Validations#save!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/transactions.rb:365:in 'block in ActiveRecord::Transactions#save!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/transactions.rb:417:in 'block (2 levels) in ActiveRecord::Transactions#with_transaction_returning_status'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_adapters/abstract/database_statements.rb:357:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#transaction'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/transactions.rb:413:in 'block in ActiveRecord::Transactions#with_transaction_returning_status'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_adapters/abstract/connection_pool.rb:412:in 'ActiveRecord::ConnectionAdapters::ConnectionPool#with_connection'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_handling.rb:310:in 'ActiveRecord::ConnectionHandling#with_connection'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/transactions.rb:409:in 'ActiveRecord::Transactions#with_transaction_returning_status'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/transactions.rb:365:in 'ActiveRecord::Transactions#save!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/suppressor.rb:56:in 'ActiveRecord::Suppressor#save!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/persistence.rb:55:in 'ActiveRecord::Persistence::ClassMethods#create!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation.rb:1362:in 'ActiveRecord::Relation#_create!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation.rb:174:in 'block in ActiveRecord::Relation#create!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation.rb:1373:in 'ActiveRecord::Relation#_scoping'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation.rb:548:in 'ActiveRecord::Relation#scoping'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation.rb:174:in 'ActiveRecord::Relation#create!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation.rb:290:in 'block (2 levels) in ActiveRecord::Relation#create_or_find_by!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_adapters/abstract/transaction.rb:626:in 'block in ActiveRecord::ConnectionAdapters::TransactionManager#within_new_transaction'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2.1/lib/active_support/concurrency/null_lock.rb:9:in 'ActiveSupport::Concurrency::NullLock#synchronize'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_adapters/abstract/transaction.rb:623:in 'ActiveRecord::ConnectionAdapters::TransactionManager#within_new_transaction'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_adapters/abstract/database_statements.rb:367:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#within_new_transaction'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_adapters/abstract/database_statements.rb:359:in 'ActiveRecord::ConnectionAdapters::DatabaseStatements#transaction'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/transactions.rb:233:in 'block in ActiveRecord::Transactions::ClassMethods#transaction'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_adapters/abstract/connection_pool.rb:412:in 'ActiveRecord::ConnectionAdapters::ConnectionPool#with_connection'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_handling.rb:310:in 'ActiveRecord::ConnectionHandling#with_connection'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/transactions.rb:232:in 'ActiveRecord::Transactions::ClassMethods#transaction'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation/delegation.rb:106:in 'ActiveRecord::Delegation#transaction'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation.rb:290:in 'block in ActiveRecord::Relation#create_or_find_by!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_adapters/abstract/connection_pool.rb:412:in 'ActiveRecord::ConnectionAdapters::ConnectionPool#with_connection'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/connection_handling.rb:310:in 'ActiveRecord::ConnectionHandling#with_connection'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation/delegation.rb:106:in 'ActiveRecord::Delegation#with_connection'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation.rb:289:in 'ActiveRecord::Relation#create_or_find_by!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/relation.rb:239:in 'ActiveRecord::Relation#find_or_create_by!'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activerecord-8.0.2.1/lib/active_record/querying.rb:24:in 'ActiveRecord::Querying#find_or_create_by!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/ppl/updater.rb:37:in 'block in Ppl::Updater#update_raw'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/ppl/updater.rb:36:in 'Array#each'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/ppl/updater.rb:36:in 'Ppl::Updater#update_raw'
# ~> 	from -:3:in '<main>'

require "./setup"
Actb::Question.import_all
# ~> /Users/ikeda/src/shogi_web/app/models/actb/question.rb:352:in `main_sfen': undefined method `moves_str' for nil:NilClass (NoMethodError)
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/question.rb:255:in `share_board_params'
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/question.rb:247:in `share_board_png_url'
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/question.rb:434:in `info'
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/question.rb:238:in `block in <class:Question>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.2.2/lib/active_support/callbacks.rb:429:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.2.2/lib/active_support/callbacks.rb:429:in `block in make_lambda'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.2.2/lib/active_support/callbacks.rb:274:in `block in simple'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.2.2/lib/active_support/callbacks.rb:518:in `block in invoke_after'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.2.2/lib/active_support/callbacks.rb:518:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.2.2/lib/active_support/callbacks.rb:518:in `invoke_after'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.2.2/lib/active_support/callbacks.rb:136:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.2.2/lib/active_support/callbacks.rb:827:in `_run_commit_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/transactions.rb:340:in `committed!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/transaction.rb:127:in `commit_records'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/transaction.rb:265:in `block in commit_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/monitor.rb:235:in `mon_synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/transaction.rb:255:in `commit_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/transaction.rb:293:in `block in within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/monitor.rb:235:in `mon_synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/transaction.rb:278:in `within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/database_statements.rb:281:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/transactions.rb:212:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/transactions.rb:366:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/persistence.rb:633:in `update!'
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/question.rb:558:in `block in import_all'
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/question.rb:556:in `each'
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/question.rb:556:in `import_all'
# ~> 	from -:2:in `<main>'
# >> load: /Users/ikeda/src/shogi_web/app/models/actb/questions.yml (13)
# >> {:moves_str=>"G*5b"}
# >> {:moves_str=>"B*9e"}

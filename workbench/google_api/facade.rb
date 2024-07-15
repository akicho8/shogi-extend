require "./setup"
facade = GoogleApi::Facade.new(rows: [{id: 1}])
facade.rows               # => [[:id], [1]]
facade.call               # => "https://docs.google.com/spreadsheets/d/1VufTa1Rv9B9ZGV1-THtWdWGgFzSZGM-fJFAgzFqnJ6c/edit"
GoogleApi::ExpirationTracker.find_each do |e|
  e.spreadsheet_delete rescue puts $!
end
# ~> /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/http_command.rb:244:in `check_status': notFound: File not found: 1HWEdgy78K6c_TT-oUzE5i9XRN99KjzTnBSB83fqUedc. (Google::Apis::ClientError)
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/api_command.rb:135:in `check_status'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/http_command.rb:207:in `process_response'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/http_command.rb:326:in `execute_once'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/http_command.rb:131:in `block (2 levels) in do_retry'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/retriable-3.1.2/lib/retriable.rb:61:in `block in retriable'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/retriable-3.1.2/lib/retriable.rb:56:in `times'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/retriable-3.1.2/lib/retriable.rb:56:in `retriable'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/http_command.rb:128:in `block in do_retry'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/retriable-3.1.2/lib/retriable.rb:61:in `block in retriable'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/retriable-3.1.2/lib/retriable.rb:56:in `times'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/retriable-3.1.2/lib/retriable.rb:56:in `retriable'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/http_command.rb:118:in `do_retry'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/http_command.rb:109:in `execute'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/base_service.rb:477:in `execute_or_queue_command'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-api-client-0.53.0/generated/google/apis/drive_v3/service.rb:962:in `delete_file'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/google_api/toolkit.rb:48:in `spreadsheet_delete'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/google_api/expiration_tracker.rb:11:in `block in <class:ExpirationTracker>'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:448:in `instance_exec'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:448:in `block in make_lambda'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:239:in `block in halting_and_conditional'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:602:in `block in invoke_after'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:602:in `each'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:602:in `invoke_after'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:111:in `run_callbacks'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:952:in `_run_destroy_callbacks'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/callbacks.rb:423:in `destroy'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/transactions.rb:305:in `block in destroy'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/transactions.rb:365:in `block in with_transaction_returning_status'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/connection_adapters/abstract/transaction.rb:535:in `block in within_new_transaction'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/concurrency/null_lock.rb:9:in `synchronize'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/connection_adapters/abstract/transaction.rb:532:in `within_new_transaction'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/connection_adapters/abstract/database_statements.rb:344:in `transaction'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/transactions.rb:361:in `with_transaction_returning_status'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/transactions.rb:305:in `destroy'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:625:in `each'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:625:in `destroy_all'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/querying.rb:23:in `destroy_all'
# ~> 	from -:5:in `<main>'
# >> 2024-07-15T03:06:04.940Z pid=55091 tid=128f INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}

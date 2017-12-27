#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

battle2_record = Battle2Record.create!
tp battle2_record
tp battle2_record.meta_info[:header]

battle2_record = Battle2Record.create!(kifu_body: "６八銀")
tp battle2_record
tp battle2_record.meta_info[:header]

# ~> /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activemodel-5.1.4/lib/active_model/attribute_methods.rb:432:in `method_missing': undefined method `meta_info' for #<Battle2Record:0x00007ff0e3c52c00> (NoMethodError)
# ~> 	from /Users/ikeda/src/shogi_web/app/models/convert_methods.rb:14:in `block (2 levels) in <module:ConvertMethods>'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:413:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:413:in `block in make_lambda'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:197:in `block (2 levels) in halting'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:601:in `block (2 levels) in default_terminator'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:600:in `catch'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:600:in `block in default_terminator'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:198:in `block in halting'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:507:in `block in invoke_before'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:507:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:507:in `invoke_before'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:130:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/airbrake-5.8.1/lib/airbrake/rails/active_record.rb:22:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activesupport-5.1.4/lib/active_support/callbacks.rb:827:in `_run_validation_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activemodel-5.1.4/lib/active_model/validations/callbacks.rb:110:in `run_validations!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activemodel-5.1.4/lib/active_model/validations.rb:335:in `valid?'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/validations.rb:65:in `valid?'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/validations.rb:82:in `perform_validations'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/validations.rb:50:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/attribute_methods/dirty.rb:43:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/transactions.rb:313:in `block in save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/transactions.rb:384:in `block in with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/connection_adapters/abstract/database_statements.rb:235:in `block in transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/connection_adapters/abstract/transaction.rb:194:in `block in within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/2.5.0/monitor.rb:226:in `mon_synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/connection_adapters/abstract/transaction.rb:191:in `within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/connection_adapters/abstract/database_statements.rb:235:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/transactions.rb:210:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/transactions.rb:381:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/transactions.rb:313:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/suppressor.rb:46:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activerecord-5.1.4/lib/active_record/persistence.rb:51:in `create!'
# ~> 	from -:4:in `<main>'

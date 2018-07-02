#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  ChatMessage.destroy_all
  User.destroy_all
  Battle.destroy_all
  Membership.destroy_all

  alice = Fanta::User.create!
  bob = Fanta::User.create!

  ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
  ActiveSupport::LogSubscriber.colorize_logging = false

  users = [alice, bob]
  battle = OwnerRoom.create!(users: users)

  tp Membership.all
end
# ~> /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activemodel-5.2.0/lib/active_model/attribute_methods.rb:430:in `method_missing': undefined method `robot_accept_key' for #<Fanta::User:0x00007ff03b85bf78> (NoMethodError)
# ~> Did you mean?  robot_accept_flag
# ~>                robot_accept_info
# ~> 	from /Users/ikeda/src/shogi_web/app/models/fanta/user.rb:90:in `block (3 levels) in <class:User>'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:426:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:426:in `block in make_lambda'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:179:in `block (2 levels) in halting_and_conditional'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:606:in `block (2 levels) in default_terminator'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:605:in `catch'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:605:in `block in default_terminator'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:180:in `block in halting_and_conditional'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:513:in `block in invoke_before'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:513:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:513:in `invoke_before'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:131:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/callbacks.rb:816:in `_run_validation_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activemodel-5.2.0/lib/active_model/validations/callbacks.rb:118:in `run_validations!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activemodel-5.2.0/lib/active_model/validations.rb:339:in `valid?'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/validations.rb:67:in `valid?'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/validations.rb:84:in `perform_validations'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/validations.rb:52:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/transactions.rb:315:in `block in save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/transactions.rb:386:in `block in with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/connection_adapters/abstract/database_statements.rb:254:in `block in transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/connection_adapters/abstract/transaction.rb:230:in `block in within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/2.5.0/monitor.rb:226:in `mon_synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/connection_adapters/abstract/transaction.rb:227:in `within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/connection_adapters/abstract/database_statements.rb:254:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/transactions.rb:212:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/transactions.rb:383:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/transactions.rb:315:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/suppressor.rb:48:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/persistence.rb:53:in `create!'
# ~> 	from -:10:in `<module:Fanta>'
# ~> 	from -:4:in `<main>'
# >> I, [2018-07-02T17:31:13.379922 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1934.83ms)
# >> I, [2018-07-02T17:31:13.465238 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.22ms)
# >> I, [2018-07-02T17:31:13.553082 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.38ms)
# >> I, [2018-07-02T17:31:13.663407 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.45ms)
# >> I, [2018-07-02T17:31:13.791173 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.32ms)
# >> I, [2018-07-02T17:31:13.883340 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.29ms)
# >> I, [2018-07-02T17:31:13.975563 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.36ms)
# >> I, [2018-07-02T17:31:14.076971 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.37ms)
# >> I, [2018-07-02T17:31:14.088571 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.28ms)
# >> I, [2018-07-02T17:31:14.099582 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.47ms)
# >> I, [2018-07-02T17:31:14.111377 #13055]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.6ms)
# >> I, [2018-07-02T17:31:14.145652 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.99ms)
# >> I, [2018-07-02T17:31:14.154361 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.91ms)
# >> I, [2018-07-02T17:31:14.162520 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.93ms)
# >> I, [2018-07-02T17:31:14.170948 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.9ms)
# >> I, [2018-07-02T17:31:14.178913 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.81ms)
# >> I, [2018-07-02T17:31:14.186976 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.99ms)
# >> I, [2018-07-02T17:31:14.195207 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.85ms)
# >> I, [2018-07-02T17:31:14.203660 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.0ms)
# >> I, [2018-07-02T17:31:14.212186 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.92ms)
# >> I, [2018-07-02T17:31:14.220948 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.95ms)
# >> I, [2018-07-02T17:31:14.229688 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.88ms)
# >> I, [2018-07-02T17:31:14.238040 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.94ms)
# >> I, [2018-07-02T17:31:14.246481 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.92ms)
# >> I, [2018-07-02T17:31:14.255057 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.93ms)
# >> I, [2018-07-02T17:31:14.263355 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.86ms)
# >> I, [2018-07-02T17:31:14.271710 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.96ms)
# >> I, [2018-07-02T17:31:14.280277 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.86ms)
# >> I, [2018-07-02T17:31:14.288388 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.89ms)
# >> I, [2018-07-02T17:31:14.296778 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.88ms)
# >> I, [2018-07-02T17:31:14.305244 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.97ms)
# >> I, [2018-07-02T17:31:14.313561 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.9ms)
# >> I, [2018-07-02T17:31:14.321613 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.9ms)
# >> I, [2018-07-02T17:31:14.330110 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.87ms)
# >> I, [2018-07-02T17:31:14.338674 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.87ms)
# >> I, [2018-07-02T17:31:14.346781 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.87ms)
# >> I, [2018-07-02T17:31:14.354782 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.91ms)
# >> I, [2018-07-02T17:31:14.363110 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.88ms)
# >> I, [2018-07-02T17:31:14.371483 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.92ms)
# >> I, [2018-07-02T17:31:14.379781 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.85ms)
# >> I, [2018-07-02T17:31:14.387891 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.92ms)
# >> I, [2018-07-02T17:31:14.395999 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.92ms)
# >> I, [2018-07-02T17:31:14.404693 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.9ms)
# >> I, [2018-07-02T17:31:14.412740 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.93ms)
# >> I, [2018-07-02T17:31:14.420977 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.86ms)
# >> I, [2018-07-02T17:31:14.429375 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.87ms)
# >> I, [2018-07-02T17:31:14.437611 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.79ms)
# >> I, [2018-07-02T17:31:14.445849 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.91ms)
# >> I, [2018-07-02T17:31:14.454337 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.92ms)
# >> I, [2018-07-02T17:31:14.462599 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.97ms)
# >> I, [2018-07-02T17:31:14.471353 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.87ms)
# >> I, [2018-07-02T17:31:14.479797 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.84ms)
# >> I, [2018-07-02T17:31:14.488028 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.92ms)
# >> I, [2018-07-02T17:31:14.496337 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.89ms)
# >> I, [2018-07-02T17:31:14.505674 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.02ms)
# >> I, [2018-07-02T17:31:14.515974 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.03ms)
# >> I, [2018-07-02T17:31:14.524724 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.97ms)
# >> I, [2018-07-02T17:31:14.533432 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.92ms)
# >> I, [2018-07-02T17:31:14.542656 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.98ms)
# >> I, [2018-07-02T17:31:14.551225 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.04ms)
# >> I, [2018-07-02T17:31:14.559643 #13055]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.9ms)

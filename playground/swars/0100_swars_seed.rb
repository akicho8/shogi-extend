#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
ForeignKey.disabled

Swars::User.destroy_all
Swars::Battle.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!
user3 = Swars::User.create!

2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user1)
    e.memberships.build(user: user2)
  end
end
2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user2)
    e.memberships.build(user: user3)
  end
end
2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user1)
    e.memberships.build(user: user3)
  end
end

# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/validations.rb:80:in `raise_validation_error': Membershipsが正しくありません (ActiveRecord::RecordInvalid)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/validations.rb:53:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/transactions.rb:302:in `block in save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/transactions.rb:354:in `block in with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/connection_adapters/abstract/database_statements.rb:320:in `block in transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/connection_adapters/abstract/transaction.rb:319:in `block in within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:26:in `block (2 levels) in synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/connection_adapters/abstract/transaction.rb:317:in `within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/connection_adapters/abstract/database_statements.rb:320:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/transactions.rb:350:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/transactions.rb:302:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/suppressor.rb:48:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/persistence.rb:55:in `create!'
# ~> 	from -:13:in `block in <main>'
# ~> 	from -:12:in `times'
# ~> 	from -:12:in `<main>'
# >> ["/Users/ikeda/src/shogi-extend/app/models/swars/membership.rb:362", nil]
# >> ["/Users/ikeda/src/shogi-extend/app/models/swars/membership.rb:362", nil]

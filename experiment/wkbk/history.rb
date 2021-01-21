require "./setup"

# tp User.sysop.wkbk_questions

# Wkbk.destroy_all
# 
user = User.sysop

question = user.wkbk_questions.create! do |e|
  e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
  e.moves_answers.build(moves_str: "G*5b")
end

user2 = User.create!

battle = Wkbk::Battle.create! do |e|
  e.memberships.build(user: user)
  e.memberships.build(user: user2)
end

history = user.wkbk_histories.create!(question: question, ox_mark: Wkbk::OxMark.fetch(:correct))
tp history

# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/inheritance.rb:205:in `compute_type': uninitialized constant User::Wkbk::MainXrecord (NameError)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/reflection.rb:424:in `compute_class'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/reflection.rb:381:in `klass'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/reflection.rb:158:in `build_association'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/association.rb:321:in `build_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/singular_association.rb:51:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/has_one_association.rb:114:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/association.rb:199:in `create!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/builder/singular_association.rb:37:in `create_wkbk_main_xrecord!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/wkbk/user_mod.rb:180:in `block (3 levels) in <module:UserMod>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `block in make_lambda'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:238:in `block in halting_and_conditional'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:517:in `block in invoke_after'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:517:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:517:in `invoke_after'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:136:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:825:in `_run_create_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/callbacks.rb:331:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/timestamp.rb:110:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/persistence.rb:905:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/callbacks.rb:327:in `block in create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:135:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:825:in `_run_save_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/callbacks.rb:327:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/timestamp.rb:128:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/persistence.rb:503:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/validations.rb:53:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:318:in `block in save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:375:in `block in with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `block in transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/transaction.rb:280:in `block in within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:26:in `block (2 levels) in synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/transaction.rb:278:in `within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:212:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:366:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:318:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/suppressor.rb:48:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/persistence.rb:55:in `create!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/user_staff_mod.rb:21:in `staff_create!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/user_staff_mod.rb:8:in `sysop'
# ~> 	from -:7:in `<main>'

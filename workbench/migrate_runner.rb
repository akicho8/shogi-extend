require "./setup"

if e = ActsAsTaggableOn::Tag.find_by(name: "原始中飛車")
  all_count = e.taggings.count
  e.taggings.in_batches(of: 100) do |relation|
    battle_ids = relation.where(taggable_type: "Swars::Membership").collect { |e| e.taggable.battle_id }.uniq
    Swars::Battle.find(battle_ids).each(&:rebuild)
  end
end
# ~> /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations.rb:318:in `association': Association named 'battle' was not found on ActsAsTaggableOn::Tagging; perhaps you misspelled it? (ActiveRecord::AssociationNotFoundError)
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations/preloader/branch.rb:79:in `block in grouped_records'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations/preloader/branch.rb:77:in `each'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations/preloader/branch.rb:77:in `grouped_records'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations/preloader/branch.rb:114:in `loaders'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations/preloader/branch.rb:71:in `runnable_loaders'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations/preloader/batch.rb:15:in `each'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations/preloader/batch.rb:15:in `flat_map'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations/preloader/batch.rb:15:in `call'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/associations/preloader.rb:121:in `call'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:882:in `block in preload_associations'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:881:in `each'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:881:in `preload_associations'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:966:in `block in exec_queries'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:1018:in `skip_query_cache_if_necessary'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:956:in `exec_queries'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/association_relation.rb:44:in `exec_queries'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:742:in `load'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation.rb:264:in `records'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation/delegation.rb:100:in `each'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation/query_methods.rb:319:in `collect'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation/query_methods.rb:319:in `extract_associated'
# ~>    from -:6:in `block in <main>'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation/batches.rb:396:in `block in batch_on_unloaded_relation'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation/batches.rb:372:in `loop'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation/batches.rb:372:in `batch_on_unloaded_relation'
# ~>    from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/relation/batches.rb:269:in `in_batches'
# ~>    from -:5:in `<main>'

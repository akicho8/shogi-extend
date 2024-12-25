require "./setup"
# Swars::Battle["fap34-StarCerisier-20200831_215840"]&.destroy!
# battle_importer = Swars::Importer::BattleImporter.new(key: Swars::BattleKey["fap34-StarCerisier-20200831_215840"], skip_if_exist: false)
# battle_importer.run
# tp battle_importer.battles.first.memberships

# Swars::Battle["raminitk-nakkunnBoy-20240823_213402"]&.destroy!
# battle_importer = Swars::Importer::BattleImporter.new(key: Swars::BattleKey["raminitk-nakkunnBoy-20240823_213402"], skip_if_exist: false, remote_run: false)
# battle_importer.run
# tp battle_importer.battles.first.memberships

key = Swars::BattleKey["KKKRRRYYY-th_1230-20241225_205830"]
Swars::Battle[key]&.destroy!
battle_importer = Swars::Importer::BattleImporter.new(key: key, skip_if_exist: false, remote_run: true)
battle_importer.run
tp battle_importer.battles.first.memberships

# ~> /Users/ikeda/src/shogi-extend/app/models/swars/battle/csa_seq_to_csa.rb:54:in `-': nil can't be coerced into Integer (TypeError)
# ~> 
# ~>           used = life[i] - t
# ~>                            ^
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/battle/csa_seq_to_csa.rb:54:in `block in render_body'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/battle/csa_seq_to_csa.rb:52:in `each'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/battle/csa_seq_to_csa.rb:52:in `with_index'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/battle/csa_seq_to_csa.rb:52:in `render_body'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/battle/csa_seq_to_csa.rb:17:in `to_csa'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/battle/core_methods.rb:46:in `to_temporary_csa'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/battle/core_methods.rb:21:in `kifu_body'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/battle_model_methods.rb:185:in `fast_parsed_info'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/battle_model_methods.rb:43:in `parsed_data_to_columns_set'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/battle/core_methods.rb:12:in `block (3 levels) in <class:Battle>'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:448:in `instance_exec'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:448:in `block in make_lambda'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:202:in `block (2 levels) in halting'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:707:in `block (2 levels) in default_terminator'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:706:in `catch'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:706:in `block in default_terminator'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:203:in `block in halting'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:598:in `block in invoke_before'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:598:in `each'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:598:in `invoke_before'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:119:in `block in run_callbacks'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:141:in `run_callbacks'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/callbacks.rb:952:in `_run_save_callbacks'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/callbacks.rb:441:in `create_or_update'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/timestamp.rb:125:in `create_or_update'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/persistence.rb:751:in `save!'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/validations.rb:55:in `save!'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/transactions.rb:313:in `block in save!'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/transactions.rb:365:in `block in with_transaction_returning_status'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/connection_adapters/abstract/transaction.rb:535:in `block in within_new_transaction'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.3.4/lib/active_support/concurrency/null_lock.rb:9:in `synchronize'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/connection_adapters/abstract/transaction.rb:532:in `within_new_transaction'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/connection_adapters/abstract/database_statements.rb:344:in `transaction'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/transactions.rb:361:in `with_transaction_returning_status'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/transactions.rb:313:in `save!'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/suppressor.rb:56:in `save!'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activerecord-7.1.3.4/lib/active_record/persistence.rb:55:in `create!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/importer/battle_importer.rb:63:in `battle_create!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/importer/battle_importer.rb:43:in `block in run'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/retryable-3.0.5/lib/retryable.rb:72:in `retryable'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/importer/battle_importer.rb:42:in `run'
# ~> 	from -:15:in `<main>'
# >> [fetch][record] https://shogiwars.heroz.jp/games/KKKRRRYYY-th_1230-20241225_205830
# >> [["+7776FU", 592], ["-8384FU", 599], ["+8877KA", 591], ["-3334FU", 597], ["+7968GI", 590], ["-7162GI", 595], ["+3948GI", 589], ["-8485FU", 594], ["+6978KI", 587], ["-4132KI", 591], ["+4746FU", 587], ["-6152KI", 587], ["+4847GI", 586], ["-6364FU", 586], ["+4756GI", 586], ["-6263GI", 586], ["+5969OU", 585], ["-6354GI", 584], ["+4958KI", 584], ["-9394FU", 584], ["+9796FU", 583], ["-7374FU", 583], ["+6979OU", 583], ["-8173KE", 581], ["+2848HI", 582], ["-8281HI", 573], ["+1716FU", 578], ["-5162OU", 571], ["+1615FU", 576], ["-2277UM", 557], ["+6877GI", 574], ["-3122GI", 556], ["+7988OU", 572], ["-2233GI", 555], ["+6766FU", 571], ["-5463GI", 521], ["+9998KY", 562], ["-5354FU", 518], ["+8899OU", 560], ["-3344GI", 517], ["+7888KI", 550], ["-2133KE", 511], ["+8878KI", 548], ["-4453GI", 508], ["+7788GI", 547], ["-8586FU", 506], ["+8786FU", 546], ["-8186HI", 500], ["+8887GI", 544], ["-8681HI", 497], ["+0086FU", 543], ["-2324FU", 392], ["+5868KI", 540], ["-2425FU", 383], ["+4828HI", 533], ["-5455FU", 347], ["+5667GI", 525], ["-4344FU", 345], ["+2726FU", 521], ["-4445FU", 328], ["+4645FU", 509], ["-8141HI", 300], ["+2848HI", 494], ["-2526FU", 298], ["+0028FU", 471], ["-0047FU", 274], ["+4847HI", 444], ["-0038KA", 271], ["+4746HI", 442], ["-3829UM", 267], ["+3736FU", 427], ["-2928UM", 264], ["+4649HI", 426], ["-0048FU", 258], ["+4948HI", 424], ["-2837UM", 249], ["+4849HI", 423], ["-2627TO", 240], ["+3635FU", 392], ["-0048FU", 235], ["+4959HI", 385], ["-5556FU", 209], ["+6756GI", 379], ["-3345KE", 196], ["+7675FU", 377], ["-0047KE", 175], ["+5979HI", 366], ["-3746UM", 168], ["+5645GI", 342], ["-4645UM", 150], ["+0056KA", 336], ["-4556UM", 142], ["+5756FU", 335], ["-4849TO", 130], ["+7574FU", 327], ["-6374GI", 128], ["+7888KI", 326], ["-0075FU", 126], ["+0076FU", 324], ["-7576FU", 115], ["+0075FU", 317], ["-7475GI", 101], ["+8776GI", 316], ["-7576GI", 100], ["+7976HI", 315], ["-0054KA", 84], ["+6665FU", 307], ["-5465KA", 82], ["+7675HI", 302], ["-0074FU", 77], ["+7565HI", 292], ["-6465FU", 73], ["+0063FU", 286], ["-5263KI", 68], ["+0055KE", 285], ["-0079GI", 61], ["+6878KI", 281], ["-7988NG", 58], ["+7888KI", 280], ["-0087FU", 56], ["+8887KI", 271], ["-0058HI", 50], ["+0088GI", 269], ["-0078KI", 43], ["+0079GI", 267], ["-7879KI", 34], ["+8879GI", 266], ["-5859RY", 33], ["+0088KA", 249], ["-5354GI", 25], ["+5563NK", 218], ["-5463GI", 23], ["+0064FU", 216], ["-6364GI", 21], ["+0054KI", 214], ["-0075KE", 18], ["+0063KI", 207], ["-6271OU", 16], ["+0076KA", 171], ["-7587NK", 14], ["+7687KA", 164], ["-0068GI", 12], ["+0069FU", 158], ["-6879GI", 10], ["+8879KA", 157], ["-0088FU", 5], ["+9988OU", 152], ["-5958RY", 2], ["+0078FU", 147], ["-5867RY", nil], ["+0072GI", 139]]
# >> "KKKRRRYYY-th_1230-20241225_205830"

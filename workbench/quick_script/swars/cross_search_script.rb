require "./setup"
QuickScript::Swars::CrossSearchScript.new(tag: "居飛車", _method: "post").as_json[:redirect_to][:to] # => "/swars/search?query=id%3A50130657%2C50130658%2C50130659%2C50130660%2C50130661%2C50130662%2C50130663%2C50130664%2C50130665%2C50130666%2C50130667%2C50130668%2C50130669%2C50130670%2C50130671%2C50130672%2C50130674%2C50130675%2C50130676%2C50130677%2C50130678%2C50130679%2C50130680%2C50130681%2C50130682%2C50130683%2C50130684%2C50130685%2C50130686%2C50130688%2C50130689%2C50130690%2C50130691%2C50130692%2C50130694%2C50130695%2C50130697%2C50130698%2C50130699%2C50130700%2C50130701%2C50130702%2C50130703%2C50130704%2C50130705%2C50130707%2C50130708%2C50130709%2C50130710%2C50130711%2C50130712%2C50130713%2C50130715%2C50130716%2C50130717%2C50130718%2C50130720%2C50130723%2C50130724%2C50130725%2C50130726%2C50130727%2C50130729%2C50130730%2C50130731%2C50130732%2C50130733%2C50130734%2C50130735%2C50130736%2C50130737%2C50130738%2C50130739%2C50130740%2C50130741%2C50130742%2C50130743%2C50130744%2C50130745%2C50130746%2C50130747%2C50130748%2C50130749%2C50130750%2C50130751%2C50130752%2C50130753%2C50130754%2C50130755%2C50130756%2C50130757%2C50130758%2C50130759%2C50130760%2C50130761%2C50130762%2C50130764%2C50130765%2C50130766%2C50130767"
_ { QuickScript::Swars::CrossSearchScript.new(tag: "居飛車", _method: "post").all_ids } # => "41.53 ms"
_ { QuickScript::Swars::CrossSearchScript.new(tag: "居飛車", _method: "post").all_ids } # => "41.76 ms"

sql
QuickScript::Swars::CrossSearchScript.new(tag: "居飛車", judge_keys: [:win, :lose], _method: "post").all_ids.size # => 100
# >>   Swars::Battle Ids (0.5ms)  SELECT `swars_battles`.`id` FROM `swars_battles` ORDER BY `swars_battles`.`id` DESC LIMIT 1000
# >>   ↳ app/models/quick_script/swars/cross_search_script.rb:159:in `with_index'
# >>   Judge Load (1.6ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'win' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:32:in `db_record!'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'lose' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:32:in `db_record!'
# >>   Swars::Battle Ids (47.3ms)  SELECT DISTINCT `swars_battles`.`id` FROM `swars_battles` INNER JOIN `swars_memberships` ON `swars_memberships`.`battle_id` = `swars_battles`.`id` INNER JOIN `taggings` `swars::membe_taggings_a7ebda8` ON `swars::membe_taggings_a7ebda8`.`taggable_id` = `swars_memberships`.`id` AND `swars::membe_taggings_a7ebda8`.`taggable_type` = 'Swars::Membership' AND `swars::membe_taggings_a7ebda8`.`tag_id` IN (SELECT `tags`.`id` FROM `tags` WHERE LOWER(`tags`.`name`) LIKE '居飛車' ESCAPE '!') WHERE `swars_battles`.`id` >= 50130657 AND `swars_memberships`.`judge_id` IN (1, 2)
# >>   ↳ app/models/quick_script/swars/cross_search_script.rb:163:in `block (2 levels) in all_ids'

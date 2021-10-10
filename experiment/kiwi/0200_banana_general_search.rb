require "./setup"

ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
current_user = User.sysop
tp Kiwi::Banana.general_search(current_user: current_user, search_preset_key: "振り飛車")       # => #<ActiveRecord::Relation []>
# tp Kiwi::Banana.general_search(current_user: current_user, search_preset_key: "非公開")       # => #<ActiveRecord::AssociationRelation [#<Kiwi::Banana id: 1, key: "Vk0RGWB59vt", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", banana_messages_count: 3, created_at: "2021-09-28 16:30:40.782828000 +0900", updated_at: "2021-09-28 16:30:41.383142000 +0900", tag_list: nil>]>
# Kiwi::Banana.general_search(search_preset_key: "右玉")
# >>   User Load (0.7ms)  SELECT `users`.* FROM `users` WHERE `users`.`key` = 'sysop' LIMIT 1
# >>   ↳ app/models/concerns/user_staff_methods.rb:17:in `staff_create!'
# >>   Kiwi::Banana Load (0.8ms)  SELECT `kiwi_bananas`.* FROM `kiwi_bananas` INNER JOIN `kiwi_folders` ON `kiwi_folders`.`id` = `kiwi_bananas`.`folder_id` INNER JOIN `taggings` `kiwi::banana_taggings_a9c1913` ON `kiwi::banana_taggings_a9c1913`.`taggable_id` = `kiwi_bananas`.`id` AND `kiwi::banana_taggings_a9c1913`.`taggable_type` = 'Kiwi::Banana' AND `kiwi::banana_taggings_a9c1913`.`tag_id` IN (SELECT `tags`.`id` FROM `tags` WHERE LOWER(`tags`.`name`) LIKE '振り飛車' ESCAPE '!') WHERE (`kiwi_folders`.`key` = 'public' OR `kiwi_bananas`.`user_id` = 1)

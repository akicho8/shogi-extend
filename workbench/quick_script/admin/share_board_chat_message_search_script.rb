require "#{__dir__}/setup"
room = ShareBoard::Room.mock
s { QuickScript::Admin::ShareBoardChatMessageSearchScript.new(room_id: room.id).call } # => {_component: "QuickScriptViewValueAsTable", _v_bind: {value: {rows: [], paginated: true, total: 0, current_page: 1, per_page: 100, always_table: true, header_hide: false}}}
s { QuickScript::Admin::ShareBoardChatMessageSearchScript.new(user_id: room.user_ids).call } # => {_component: "QuickScriptViewValueAsTable", _v_bind: {value: {rows: [], paginated: true, total: 0, current_page: 1, per_page: 100, always_table: true, header_hide: false}}}
# >>   ShareBoard::ChatMessage Load (1.2ms)  SELECT `share_board_chat_messages`.* FROM `share_board_chat_messages` WHERE `share_board_chat_messages`.`room_id` = 14 ORDER BY `share_board_chat_messages`.`created_at` DESC, `share_board_chat_messages`.`id` DESC LIMIT 100 OFFSET 0 /*application='ShogiWeb'*/
# >>   ↳ app/models/quick_script/admin/share_board_chat_message_search_script.rb:20:in 'Enumerable#collect'
# >>   ShareBoard::User Pluck (0.4ms)  SELECT `share_board_users`.`id` FROM `share_board_users` INNER JOIN `share_board_roomships` ON `share_board_users`.`id` = `share_board_roomships`.`user_id` WHERE `share_board_roomships`.`room_id` = 14 ORDER BY `share_board_roomships`.`rank` ASC /*application='ShogiWeb'*/
# >>   ShareBoard::ChatMessage Load (0.4ms)  SELECT `share_board_chat_messages`.* FROM `share_board_chat_messages` WHERE `share_board_chat_messages`.`user_id` IN (1, 3, 2) ORDER BY `share_board_chat_messages`.`created_at` DESC, `share_board_chat_messages`.`id` DESC LIMIT 100 OFFSET 0 /*application='ShogiWeb'*/
# >>   ↳ app/models/quick_script/admin/share_board_chat_message_search_script.rb:20:in 'Enumerable#collect'

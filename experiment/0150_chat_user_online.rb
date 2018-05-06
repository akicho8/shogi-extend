#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

user = ChatUser.create!
# user.appear
# user.disappear
user.reload.destroy
tp user
# >> {"id"=>[nil, 7], "name"=>[nil, "野良5号"], "lifetime_key"=>[nil, "lifetime5_min"], "ps_preset_key"=>[nil, "平手"], "po_preset_key"=>[nil, "平手"], "created_at"=>[nil, Sun, 06 May 2018 15:27:29 JST +09:00], "updated_at"=>[nil, Sun, 06 May 2018 15:27:29 JST +09:00]}
# >> {}
# >> |----------------------+---------------------------|
# >> |                   id | 7                         |
# >> |                 name | 野良5号                   |
# >> | current_chat_room_id |                           |
# >> |            online_at |                           |
# >> |          matching_at |                           |
# >> |         lifetime_key | lifetime5_min             |
# >> |        ps_preset_key | 平手                      |
# >> |        po_preset_key | 平手                      |
# >> |           created_at | 2018-05-06 15:27:29 +0900 |
# >> |           updated_at | 2018-05-06 15:27:29 +0900 |
# >> |----------------------+---------------------------|

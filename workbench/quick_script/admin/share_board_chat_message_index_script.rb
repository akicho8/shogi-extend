require "#{__dir__}/setup"
# s { ShareBoard::ChatMessage.where(ShareBoard::ChatMessage.arel_table[:created_at].gteq(24.hours.ago)).select(:room_id).distinct } # => #<ActiveRecord::Relation [#<ShareBoard::ChatMessage room_id: 1, id: nil>, #<ShareBoard::ChatMessage room_id: 5, id: nil>]>
# ShareBoard::ChatMessage.where(ShareBoard::ChatMessage.arel_table[:created_at].gteq(24.hours.ago)).select(:room_id).distinct.pluck(:room_id) # => [1, 5]

# ShareBoard::ChatMessage.where(created_at: ...24.hours.ago).to_sql # => "SELECT `share_board_chat_messages`.* FROM `share_board_chat_messages` WHERE `share_board_chat_messages`.`created_at` < '2025-08-02 02:49:28'"
# ShareBoard::ChatMessage.where(created_at: ..24.hours.ago).to_sql  # => "SELECT `share_board_chat_messages`.* FROM `share_board_chat_messages` WHERE `share_board_chat_messages`.`created_at` <= '2025-08-02 02:49:28'"
# ShareBoard::ChatMessage.where(created_at: 24.hours.ago..).to_sql  # => "SELECT `share_board_chat_messages`.* FROM `share_board_chat_messages` WHERE `share_board_chat_messages`.`created_at` >= '2025-08-02 02:49:28'"
# ShareBoard::ChatMessage.where(created_at: 24.hours.ago...).to_sql # => "SELECT `share_board_chat_messages`.* FROM `share_board_chat_messages` WHERE `share_board_chat_messages`.`created_at` >= '2025-08-02 02:49:28'"

room_ids = ShareBoard::ChatMessage.where(created_at: 24.hours.ago..).distinct.pluck(:room_id) # => [1, 5]

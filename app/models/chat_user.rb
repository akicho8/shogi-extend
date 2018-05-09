# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 件名と本文のみテーブル (room_chat_messages as RoomChatMessage)
#
# +------------+----------+----------+-------------+------+-------+
# | カラム名   | 意味     | タイプ   | 属性        | 参照 | INDEX |
# +------------+----------+----------+-------------+------+-------+
# | id         | ID       | integer  | NOT NULL PK |      |       |
# | subject    | 件名     | string   |             |      |       |
# | body       | 内容     | text     |             |      |       |
# | created_at | 作成日時 | datetime | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime | NOT NULL    |      |       |
# +------------+----------+----------+-------------+------+-------+

class ChatUser < ApplicationRecord
  has_many :room_chat_messages, dependent: :destroy
  has_many :lobby_chat_messages, dependent: :destroy
  has_many :chat_memberships, dependent: :destroy
  has_many :chat_rooms, through: :chat_memberships
  has_many :owner_rooms, class_name: "ChatRoom", foreign_key: :room_owner_id, dependent: :destroy, inverse_of: :room_owner # 自分が作った部屋
  belongs_to :current_chat_room, class_name: "ChatRoom", optional: true, counter_cache: :current_chat_users_count # 今入っている部屋

  has_many :kansen_memberships, dependent: :destroy                        # 自分が観戦している部屋たち(中間情報)
  has_many :kansen_rooms, through: :kansen_memberships, source: :chat_room # 自分が観戦している部屋たち

  before_validation on: :create do
    self.name ||= "野良#{ChatUser.count.next}号"
    self.ps_preset_key ||= "平手"
    self.po_preset_key ||= "平手"
    self.lifetime_key ||= "lifetime5_min"
  end

  def js_attributes
    JSON.load(to_json)
  end

  after_commit do
    # FIXME: 重い
    online_users = self.class.online_only
    online_users = online_users.collect do |e|
      e.attributes.merge(current_chat_room: e.current_chat_room&.js_attributes)
    end
    ActionCable.server.broadcast("lobby_channel", online_users: online_users)
  end

  concerning :OnlineMethods do
    included do
      scope :online_only, -> { where.not(online_at: nil) }

      after_commit do
        if saved_changes[:online_at]
          online_only_count_update
        end
      end

      after_destroy_commit :online_only_count_update
    end

    def appear
      update!(online_at: Time.current)
    end

    def disappear
      update!(online_at: nil)
    end

    def online_only_count_update
      ActionCable.server.broadcast("system_notification_channel", {online_only_count: self.class.online_only.count})
    end
  end

  concerning :ActiveFighterMethods do
    included do
      scope :fighter_only, -> { where.not(fighting_now_at: nil) }

      after_commit do
        if saved_changes[:fighting_now_at]
          fighter_only_count_update
        end
      end

      after_destroy_commit :fighter_only_count_update
    end

    def fighter_only_count_update
      ActionCable.server.broadcast("system_notification_channel", {fighter_only_count: self.class.fighter_only.count})
    end
  end

  concerning :MathingMethods do
    def matching_start
      s = ChatUser.all
      s = s.online_only
      s = s.where.not(id: id)                   # 自分以外
      s = s.where.not(matching_at: nil)                           # マッチング希望者
      s = s.where(lifetime_key: lifetime_key)   # 同じ持ち時間
      s = s.where(ps_preset_key: po_preset_key) # 「相手から見た自分」と「相手」の手合が一致する
      s = s.where(po_preset_key: ps_preset_key) # 「相手から見た相手」と「自分」の手合が一致する

      # 誰もいなかったら登録する
      if s.count == 0
        update!(matching_at: Time.current)
        LobbyChannel.broadcast_to(self, {matching_wait: {matching_at: matching_at}})
      else
        opponent = s.sample
        opponent.update!(matching_at: nil) # 相手のマッチング状態を解除

        users = [self, opponent]
        if users.all? { |e| e.ps_preset_key == "平手" }
          preset_key = "平手"
          users = users.shuffle
        else
          users = users.sort_by { |e| (e.ps_preset_key == "平手") ? 0 : 1 }
          preset_key = users.last.ps_preset_key
        end

        chat_room = opponent.owner_rooms.create!(chat_users: users, preset_key: preset_key, auto_matched_at: Time.current)

        chat_room.chat_users.each do |chat_user|
          ActionCable.server.broadcast("single_notification_#{chat_user.id}", {
              matching_ok: true,
              chat_room: chat_room.js_attributes,
            })
        end
      end
    end
  end
end

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

class ChatRoom < ApplicationRecord
  has_many :room_chat_messages, dependent: :destroy
  has_many :chat_memberships, dependent: :destroy
  has_many :chat_users, through: :chat_memberships
  has_many :current_chat_users, class_name: "ChatUser", foreign_key: :current_chat_room_id, dependent: :nullify
  belongs_to :room_owner, class_name: "ChatUser"

  has_many :kansen_memberships, dependent: :destroy                        # 観戦中の人たち(中間情報)
  has_many :kansen_users, through: :kansen_memberships, source: :chat_user # 観戦中の人たち

  scope :latest_list, -> { order(updated_at: :desc).limit(50) }

  cattr_accessor(:to_json_params) { {include: [:room_owner, :chat_users, :kansen_users], methods: [:show_path]} }

  serialize :clock_counts

  before_validation on: :create do
    self.name = name.presence || name_default
    self.preset_key ||= "平手"
    self.lifetime_key ||= :lifetime5_min
    # self.kifu_body_sfen ||= "position startpos"
    self.turn_max ||= 0
    self.clock_counts ||= {black: [], white: []}
  end

  before_validation do
    if changes_to_save[:preset_key] && preset_key
      preset_info = Warabi::PresetInfo.fetch(preset_key)
      self.kifu_body_sfen = preset_info.to_position_sfen
    end
  end

  def name_default
    if chat_users.present?
      chat_users.collect(&:name).join(" vs ")
    else
      names = []
      if room_owner
        names << "#{room_owner.name}の"
      end
      names << "対戦部屋 ##{ChatRoom.count.next}"
      names.join
    end
  end

  def human_kifu_text_get
    info = Warabi::Parser.parse(kifu_body_sfen, typical_error_case: :embed)
    begin
      mediator = info.mediator
    rescue => error
      return error.message
    end
    info.to_ki2
  end

  after_commit do
    broadcast
  end

  def broadcast
    ActionCable.server.broadcast("lobby_channel", chat_rooms: JSON.load(self.class.latest_list.to_json(to_json_params)))
    ActionCable.server.broadcast("chat_room_channel_#{id}", chat_room: js_attributes) # FIXME: これは重いだけで使ってないのではずす
  end

  def js_attributes
    JSON.load(to_json(to_json_params))
  end

  def js_room_members
    JSON.load(chat_memberships.to_json(include: [:chat_user]))
  end

  private

  def show_path
    Rails.application.routes.url_helpers.url_for([:resource_ns1, self, only_path: true])
  end
end

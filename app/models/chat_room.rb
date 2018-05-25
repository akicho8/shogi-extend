# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対戦部屋テーブル (chat_rooms as ChatRoom)
#
# |--------------------------+--------------------------+-------------+---------------------+----------------+-------|
# | カラム名                 | 意味                     | タイプ      | 属性                | 参照           | INDEX |
# |--------------------------+--------------------------+-------------+---------------------+----------------+-------|
# | id                       | ID                       | integer(8)  | NOT NULL PK         |                |       |
# | room_owner_id            | Room owner               | integer(8)  | NOT NULL            | => ChatUser#id | A     |
# | black_preset_key         | Black preset key         | string(255) | NOT NULL            |                |       |
# | white_preset_key         | White preset key         | string(255) | NOT NULL            |                |       |
# | lifetime_key             | Lifetime key             | string(255) | NOT NULL            |                |       |
# | name                     | 部屋名                   | string(255) | NOT NULL            |                |       |
# | kifu_body_sfen           | Kifu body sfen           | text(65535) | NOT NULL            |                |       |
# | clock_counts             | Clock counts             | text(65535) | NOT NULL            |                |       |
# | turn_max                 | Turn max                 | integer(4)  | NOT NULL            |                |       |
# | battle_request_at        | Battle request at        | datetime    |                     |                |       |
# | auto_matched_at          | Auto matched at          | datetime    |                     |                |       |
# | begin_at                 | Begin at                 | datetime    |                     |                |       |
# | end_at                   | End at                   | datetime    |                     |                |       |
# | last_action_key          | Last action key          | string(255) |                     |                |       |
# | win_location_key         | Win location key         | string(255) |                     |                |       |
# | current_chat_users_count | Current chat users count | integer(4)  | DEFAULT(0) NOT NULL |                |       |
# | watch_memberships_count  | Watch memberships count  | integer(4)  | DEFAULT(0) NOT NULL |                |       |
# | created_at               | 作成日時                 | datetime    | NOT NULL            |                |       |
# | updated_at               | 更新日時                 | datetime    | NOT NULL            |                |       |
# |--------------------------+--------------------------+-------------+---------------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・ChatRoom モデルは ChatUser モデルから has_many :owner_rooms, :foreign_key => :room_owner_id されています。
#--------------------------------------------------------------------------------

class ChatRoom < ApplicationRecord
  time_rangable default: false

  has_many :room_chat_messages, dependent: :destroy
  has_many :chat_memberships, dependent: :destroy
  has_many :chat_users, through: :chat_memberships
  has_many :current_chat_users, class_name: "ChatUser", foreign_key: :current_chat_room_id, dependent: :nullify
  belongs_to :room_owner, class_name: "ChatUser"

  has_many :watch_memberships, dependent: :destroy                        # 観戦中の人たち(中間情報)
  has_many :watch_users, through: :watch_memberships, source: :chat_user # 観戦中の人たち

  scope :latest_list, -> { order(updated_at: :desc).limit(50) }

  # FIXME: chat_users は無駄
  cattr_accessor(:to_json_params) {
    {include: {
        :room_owner => nil,
        :chat_users => nil,
        :watch_users => nil,
        :chat_memberships => {
          include: :chat_user,
        },
      }, methods: [
        :show_path,
        :handicap,
      ],
    }
  }

  serialize :clock_counts
  serialize :countdown_mode_hash

  before_validation on: :create do
    self.name = name.presence || name_default
    self.black_preset_key ||= "平手"
    self.white_preset_key ||= "平手"
    self.lifetime_key ||= :lifetime5_min
    # self.kifu_body_sfen ||= "position startpos"
    self.turn_max ||= 0
    self.clock_counts ||= {black: [], white: []}
    self.countdown_mode_hash ||= {black: false, white: false}
  end

  before_validation do
    if (changes_to_save[:black_preset_key] || changes_to_save[:white_preset_key]) && black_preset_key && white_preset_key

      # preset_info = Warabi::PresetInfo.fetch(preset_key)
      # self.kifu_body_sfen = preset_info.to_position_sfen

      mediator = Warabi::Mediator.new
      mediator.board.placement_from_hash(black: black_preset_key, white: white_preset_key)
      mediator.turn_info.handicap = handicap
      self.kifu_body_sfen = "position #{mediator.to_long_sfen}"
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

  def human_kifu_text
    info = Warabi::Parser.parse(kifu_body_sfen, typical_error_case: :embed)
    begin
      mediator = info.mediator
    rescue => error
      return error.message
    end
    info.names_set(names_hash)
    info.to_ki2
  end

  after_commit do
    broadcast
  end

  def broadcast
    # ActionCable.server.broadcast("lobby_channel", chat_rooms: JSON.load(self.class.latest_list.to_json(to_json_params)))
    ActionCable.server.broadcast("chat_room_channel_#{id}", chat_room: js_attributes) # FIXME: これは重いだけで使ってないのではずす
  end

  def js_attributes
    JSON.load(to_json(to_json_params))
  end

  def js_room_members
    JSON.load(chat_memberships.to_json(include: [:chat_user]))
  end

  def show_path
    Rails.application.routes.url_helpers.url_for([:resource_ns1, self, only_path: true])
  end

  def handicap
    !(black_preset_key == "平手" && white_preset_key == "平手")
  end

  def names_hash
    chat_memberships.group_by(&:location_key).transform_values { |a| a.collect { |e| e.chat_user.name }.join("・") }.symbolize_keys
  end
end

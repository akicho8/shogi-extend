# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (chat_users as ChatUser)
#
# |----------------------+-------------------+-------------+-------------+----------------+-------|
# | カラム名             | 意味              | タイプ      | 属性        | 参照           | INDEX |
# |----------------------+-------------------+-------------+-------------+----------------+-------|
# | id                   | ID                | integer(8)  | NOT NULL PK |                |       |
# | name                 | 名前              | string(255) | NOT NULL    |                |       |
# | current_chat_room_id | Current chat room | integer(8)  |             | => ChatRoom#id | A     |
# | online_at            | Online at         | datetime    |             |                |       |
# | fighting_now_at      | Fighting now at   | datetime    |             |                |       |
# | matching_at          | Matching at       | datetime    |             |                |       |
# | lifetime_key         | Lifetime key      | string(255) | NOT NULL    |                | B     |
# | ps_preset_key        | Ps preset key     | string(255) | NOT NULL    |                | C     |
# | po_preset_key        | Po preset key     | string(255) | NOT NULL    |                | D     |
# | created_at           | 作成日時          | datetime    | NOT NULL    |                |       |
# | updated_at           | 更新日時          | datetime    | NOT NULL    |                |       |
# |----------------------+-------------------+-------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・ChatUser モデルは ChatRoom モデルから has_many :current_chat_users, :foreign_key => :current_chat_room_id されています。
#--------------------------------------------------------------------------------

class ChatUser < ApplicationRecord
  has_many :room_chat_messages, dependent: :destroy
  has_many :lobby_chat_messages, dependent: :destroy
  has_many :chat_memberships, dependent: :destroy
  has_many :chat_rooms, through: :chat_memberships
  belongs_to :current_chat_room, class_name: "ChatRoom", optional: true, counter_cache: :current_chat_users_count # 今入っている部屋

  has_many :watch_memberships, dependent: :destroy                        # 自分が観戦している部屋たち(中間情報)
  has_many :watch_rooms, through: :watch_memberships, source: :chat_room # 自分が観戦している部屋たち

  before_validation on: :create do
    self.name ||= "野良#{ChatUser.count.next}号"
    self.ps_preset_key ||= "平手"
    self.po_preset_key ||= "平手"
    self.lifetime_key ||= "lifetime5_min"
  end

  # def js_attributes
  #   as_json
  # end

  # def as_json(**args)
  #   super({methods: :avatar_url}.merge(args))
  # end

  after_commit do
    ActionCable.server.broadcast("lobby_channel", online_users: ams_sr(self.class.online_only)) # 重い
  end

  concerning :AvatarMethods do
    included do
      has_one_attached :avatar

      cattr_accessor :icon_files do
        relative_path = Rails.root.join("app/assets/images")
        relative_path.join("fallback_icons").glob("0*.png").collect do |e|
          e.relative_path_from(relative_path)
        end
      end
    end

    # FALLBACK_ICONS_DEBUG=1 fs
    def avatar_url
      if ENV["FALLBACK_ICONS_DEBUG"]
        return ActionController::Base.helpers.asset_path(icon_files.sample)
      end

      if avatar.attached?
        # ▼Activestorrage service_url missing default_url_options[:host] · Issue #32866 · rails/rails
        # https://github.com/rails/rails/issues/32866
        Rails.application.routes.url_helpers.rails_blob_path(avatar, only_path: true)
      else
        file = icon_files[id.modulo(icon_files.size)]
        ActionController::Base.helpers.asset_path(file)
      end
    end
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
      s = s.where.not(matching_at: nil)         # マッチング希望者
      s = s.where(lifetime_key: lifetime_key)   # 同じ持ち時間
      s = s.where(ps_preset_key: po_preset_key) # 「相手から見た自分」と「相手」の手合が一致する
      s = s.where(po_preset_key: ps_preset_key) # 「相手から見た相手」と「自分」の手合が一致する

      if s.count == 0
        # 誰もいなかったら登録する
        update!(matching_at: Time.current)
        LobbyChannel.broadcast_to(self, {matching_wait: {matching_at: matching_at}})
      else
        # 誰かいたので相手を見つける
        battle_match_to(s.sample, chat_room: {auto_matched_at: Time.current})
      end
    end

    # 自分のルールを優先する
    def battle_match_to(opponent, **options)
      options = {
        chat_room: {},
      }.merge(options)

      room_params = users_and_preset_key(opponent)
      chat_room = ChatRoom.create!(room_params.slice(:black_preset_key, :white_preset_key).merge(lifetime_key: lifetime_key).merge(options[:chat_room]))
      room_params[:chat_users].each do |user|
        user.update!(matching_at: nil) # 互いのマッチング状態をリセット
        chat_room.chat_users << user
      end
      chat_room.chat_users.each do |chat_user|
        ActionCable.server.broadcast("single_notification_#{chat_user.id}", {matching_ok: true, chat_room: ams_sr(chat_room)})
      end
    end

    def users_and_preset_key(opponent)
      users = [self, opponent]

      if ps_preset_key == "平手" && po_preset_key == "平手"
        # 相平手
        users = users.shuffle
      elsif ps_preset_key == "平手"
        users = [self, opponent]
      elsif po_preset_key == "平手"
        users = [opponent, self]
      else
        # 両方駒落ち
        ps = Warabi::PresetInfo[ps_preset_key]
        po = Warabi::PresetInfo[po_preset_key]
        if ps.formal_level == po.formal_level
          # 両方同じ駒落ち
          users = users.shuffle
        elsif ps.formal_level > po.formal_level
          # 同じ駒落ちだけど自分の方が格式が高いので上手ということで△側
          users = [opponent, self]
        else
          users = [self, opponent]
        end
      end

      if users.first == self
        black_preset_key = ps_preset_key
        white_preset_key = po_preset_key
      else
        black_preset_key = po_preset_key
        white_preset_key = ps_preset_key
      end

      {chat_users: users, black_preset_key: black_preset_key, white_preset_key: white_preset_key}
    end
  end
end

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (users as Fanta::User)
#
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | カラム名               | 意味                | タイプ      | 属性        | 参照             | INDEX |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | id                     | ID                  | integer(8)  | NOT NULL PK |                  |       |
# | name                   | 名前                | string(255) | NOT NULL    |                  |       |
# | current_battle_id | Current battle room | integer(8)  |             | => Fanta::Battle#id | A     |
# | online_at              | Online at           | datetime    |             |                  |       |
# | fighting_at            | Fighting at         | datetime    |             |                  |       |
# | matching_at            | Matching at         | datetime    |             |                  |       |
# | lifetime_key           | Lifetime key        | string(255) | NOT NULL    |                  | B     |
# | platoon_key            | Platoon key         | string(255) | NOT NULL    |                  | C     |
# | self_preset_key        | Self preset key     | string(255) | NOT NULL    |                  | D     |
# | oppo_preset_key        | Oppo preset key     | string(255) | NOT NULL    |                  | E     |
# | user_agent             | Fanta::User agent          | string(255) | NOT NULL    |                  |       |
# | created_at             | 作成日時            | datetime    | NOT NULL    |                  |       |
# | updated_at             | 更新日時            | datetime    | NOT NULL    |                  |       |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・Fanta::User モデルは Fanta::Battle モデルから has_many :current_users, :foreign_key => :current_battle_id されています。
#--------------------------------------------------------------------------------

class Fanta::User < ApplicationRecord
  has_many :chat_messages, dependent: :destroy
  has_many :lobby_messages, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :battles, through: :memberships
  belongs_to :current_battle, class_name: "Fanta::Battle", optional: true, counter_cache: :current_users_count # 今入っている部屋

  has_many :watch_ships, dependent: :destroy                        # 自分が観戦している部屋たち(中間情報)
  has_many :watch_rooms, through: :watch_ships, source: :battle # 自分が観戦している部屋たち

  scope :random_order, -> { order(Arel.sql("rand()")) }

  before_validation on: :create do
    self.name ||= "野良#{Fanta::User.count.next}号"
    self.self_preset_key ||= "平手"
    self.oppo_preset_key ||= "平手"
    self.lifetime_key ||= "lifetime_m5"
    self.platoon_key ||= "platoon_p1vs1"
    self.user_agent ||= ""
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

  def lifetime_info
    Fanta::LifetimeInfo.fetch(lifetime_key)
  end

  def platoon_info
    Fanta::PlatoonInfo.fetch(platoon_key)
  end

  def self_preset_info
    Warabi::PresetInfo[self_preset_key]
  end

  def oppo_preset_info
    Warabi::PresetInfo[oppo_preset_key]
  end

  def show_path
    Rails.application.routes.url_helpers.url_for([self, only_path: true])
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
      scope :fighter_only, -> { where.not(fighting_at: nil) }

      after_commit do
        if saved_changes[:fighting_at]
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
    included do
      scope :preset_scope, -> self_preset_key, oppo_preset_key { where(self_preset_key: self_preset_key).where(oppo_preset_key: oppo_preset_key) }
    end

    def matching_start
      update!(matching_at: Time.current) # マッチング対象にして待つ

      s = matching_scope

      if rule_cop.same_rule?
        s = s.merge(preset_reverse)
        if s.count < platoon_info.total_limit
          matching_wait_notify
          return
        end
        users = s.random_order.limit(platoon_info.total_limit) # 人数に達したのでそのメンバーをランダムで取得
        pair_list = users.each_slice(2).to_a
      else
        s1 = s.merge(preset_equal)   # 自分の味方を探す
        s2 = s.merge(preset_reverse) # 相手を探す
        if s1.count < platoon_info.half_limit || s2.count < platoon_info.half_limit
          matching_wait_notify
          return
        end
        users1 = s1.limit(platoon_info.half_limit)
        users2 = s2.limit(platoon_info.half_limit)
        pair_list = users1.zip(users2)
      end

      battle_setup(pair_list, auto_matched_at: Time.current)
    end

    def battle_setup_with(opponent)
      battle_setup([[self, opponent]], {battle_request_at: Time.current})
    end

    # 手合割を考慮して自分と相手の座席を決定する
    def seat_determination(opponent)
      a = [self, opponent]
      case
      when rule_cop.same_rule?
        a = a.shuffle
      when rule_cop.teacher?
        a = a.reverse
      end
      a
    end

    private

    def battle_setup(pair_list, **attributes)
      battle = battle_create(attributes)

      pair_list.flatten.each { |e| e.update!(matching_at: nil) } # マッチング状態をリセット

      # 二人ずつ取り出して振り分ける
      pair_list.each do |a, b|
        a.seat_determination(b).each do |user|
          battle.users << user
        end
      end

      # 召集
      battle.users.each do |user|
        ActionCable.server.broadcast("single_notification_#{user.id}", {matching_ok: true, battle_show_path: battle.show_path}.merge(attributes))
      end

      battle
    end

    def battle_create(attributes = {})
      Fanta::Battle.create! do |e|
        e.lifetime_key = lifetime_key
        e.platoon_key = platoon_key
        e.attributes = [:black_preset_key, :white_preset_key].zip(rule_cop.to_a).to_h
        e.attributes = attributes
        e.save!
      end
    end

    def matching_wait_notify
      LobbyChannel.broadcast_to(self, {matching_wait: {matching_at: matching_at}})
    end

    def matching_scope
      s = self.class.all
      s = s.online_only                         # オンラインの人のみ
      s = s.where.not(matching_at: nil)         # マッチング希望者
      s = s.where(lifetime_key: lifetime_key)   # 同じ持ち時間
      s = s.where(platoon_key: platoon_key)     # 人数モード
    end

    # 自分と同じ条件
    def preset_equal
      self.class.preset_scope(self_preset_key, oppo_preset_key)
    end

    # 自分が探している人
    def preset_reverse
      self.class.preset_scope(oppo_preset_key, self_preset_key)
    end

    def rule_cop
      Fanta::RuleCop.new(self_preset_key, oppo_preset_key)
    end

    class Fanta::RuleCop
      attr_accessor :self_preset_key
      attr_accessor :oppo_preset_key

      def initialize(self_preset_key, oppo_preset_key)
        @self_preset_key = self_preset_key
        @oppo_preset_key = oppo_preset_key
      end

      def self_preset_info
        Warabi::PresetInfo[self_preset_key]
      end

      def oppo_preset_info
        Warabi::PresetInfo[oppo_preset_key]
      end

      def same_rule?
        self_preset_info == oppo_preset_info
      end

      # 駒をたくさん落している方が先生
      def teacher?
        self_preset_info > oppo_preset_info
      end

      # 駒が充足している方が生徒
      def student?
        self_preset_info < oppo_preset_info
      end

      def to_a
        a = [self_preset_info.key, oppo_preset_info.key]
        if teacher?
          a = a.reverse
        end
        a
      end
    end
  end
end

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (fanta_users as Fanta::User)
#
# |-------------------+------------------+-------------+-------------+------+-------|
# | カラム名          | 意味             | タイプ      | 属性        | 参照 | INDEX |
# |-------------------+------------------+-------------+-------------+------+-------|
# | id                | ID               | integer(8)  | NOT NULL PK |      |       |
# | key               | Key              | string(255) | NOT NULL    |      | A!    |
# | name              | Name             | string(255) | NOT NULL    |      |       |
# | current_battle_id | Current battle   | integer(8)  |             |      | B     |
# | online_at         | Online at        | datetime    |             |      |       |
# | fighting_at       | Fighting at      | datetime    |             |      |       |
# | matching_at       | Matching at      | datetime    |             |      |       |
# | cpu_brain_key     | Cpu brain key    | string(255) |             |      |       |
# | user_agent        | User agent       | string(255) | NOT NULL    |      |       |
# | lifetime_key      | Lifetime key     | string(255) | NOT NULL    |      | C     |
# | platoon_key       | Platoon key      | string(255) | NOT NULL    |      | D     |
# | self_preset_key   | Self preset key  | string(255) | NOT NULL    |      | E     |
# | oppo_preset_key   | Oppo preset key  | string(255) | NOT NULL    |      | F     |
# | robot_accept_key  | Robot accept key | string(255) | NOT NULL    |      | G     |
# | race_key          | Race key         | string(255) | NOT NULL    |      | H     |
# | created_at        | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時         | datetime    | NOT NULL    |      |       |
# |-------------------+------------------+-------------+-------------+------+-------|

module Fanta
  CpuBrainInfo

  class User < ApplicationRecord
    class << self
      def setup(options = {})
        super

        sysop

        CpuBrainInfo.each do |e|
          unless find_by(key: e.key)
            create!(key: e.key, name: "#{e.name}CPU", race_key: :robot, online_at: Time.current, cpu_brain_key: e.key)
          end
        end

        if Rails.env.development?
          2.times.collect do
            create!(platoon_key: "platoon_p2vs2")
          end
        end
      end
    end

    scope :random_order, -> { order(Arel.sql("rand()")) }

    before_validation on: :create do
      self.key ||= SecureRandom.hex
      self.user_agent ||= ""

      if race_info.key == :human
        self.name ||= "野良#{self.class.human_only.count.next}号"
      else
        self.name ||= "CPU#{self.class.robot_only.count.next}号"
      end

      if Rails.env.development?
        self.online_at ||= Time.current
      end
    end

    def show_path
      Rails.application.routes.url_helpers.url_for([self, only_path: true])
    end

    concerning :RuleMethods do
      included do
        before_validation on: :create do
          self.self_preset_key  ||= "平手"
          self.oppo_preset_key  ||= "平手"
          self.lifetime_key     ||= :lifetime_m5
          self.platoon_key      ||= :platoon_p1vs1
          self.robot_accept_key ||= "accept"
        end

        with_options allow_blank: true do
          validates :self_preset_key,  inclusion: CustomPresetInfo.keys.collect(&:to_s)
          validates :oppo_preset_key,  inclusion: CustomPresetInfo.keys.collect(&:to_s)
          validates :lifetime_key,     inclusion: LifetimeInfo.keys.collect(&:to_s)
          validates :platoon_key,      inclusion: PlatoonInfo.keys.collect(&:to_s)
          validates :robot_accept_key, inclusion: RobotAcceptInfo.keys.collect(&:to_s)
        end
      end

      def self_preset_info
        CustomPresetInfo.fetch(self_preset_key)
      end

      def oppo_preset_info
        CustomPresetInfo.fetch(oppo_preset_key)
      end

      def lifetime_info
        LifetimeInfo.fetch(lifetime_key)
      end

      def platoon_info
        PlatoonInfo.fetch(platoon_key)
      end

      def robot_accept_info
        RobotAcceptInfo.fetch(robot_accept_key)
      end
    end

    concerning :ChatMessageMethods do
      included do
        has_many :chat_messages, dependent: :destroy
      end

      class_methods do
        def sysop
          find_by(key: __method__) || create!(key: "sysop", name: "SYSOP")
        end
      end

      def chat_say(battle, message, msg_options = {})
        chat_message = chat_messages.create!(battle: battle, message: message, msg_options: msg_options)
        ActionCable.server.broadcast(battle.channel_key, chat_message: ams_sr(chat_message))
      end
    end

    concerning :LobbyMethods do
      included do
        has_many :lobby_messages, dependent: :destroy

        after_create_commit  { cud_broadcast(:create)  }
        after_update_commit  { cud_broadcast(:update)  }
        after_destroy_commit { cud_broadcast(:destroy) }
      end

      def cud_broadcast(action)
        ActionCable.server.broadcast("lobby_channel", user_cud: {action: action, user: ams_sr(self, serializer: OnlineUserSerializer)})
      end

      def lobby_chat_say(message, msg_options = {})
        lobby_message = lobby_messages.create!(message: message, msg_options: msg_options)
        ActionCable.server.broadcast("lobby_channel", lobby_message: ams_sr(lobby_message))
      end
    end

    concerning :RaceMethods do
      included do
        before_validation on: :create do
          self.race_key ||= race_info.key
        end
      end

      def race_info
        RaceInfo.fetch(race_key || :human)
      end
    end

    concerning :CpuBrainMethods do
      def cpu_brain_info
        CpuBrainInfo.fetch(cpu_brain_key || :level1)
      end
    end

    concerning :AvatarMethods do
      included do
        has_one_attached :avatar
      end

      class_methods do
        def image_files(name)
          @image_files ||= {}
          @image_files[name] ||= -> {
            root_dir = Rails.root.join("app/assets/images")
            root_dir.join(name.to_s).glob("0*.png").collect do |e|
              e.relative_path_from(root_dir)
            end
          }.call
        end
      end

      # FALLBACK_ICONS_DEBUG=1 foreman s
      def avatar_url
        if ENV["FALLBACK_ICONS_DEBUG"]
          return ActionController::Base.helpers.asset_path(self.class.image_files(:robot).sample)
        end

        if avatar.attached?
          # ▼Activestorrage service_url missing default_url_options[:host] · Issue #32866 · rails/rails
          # https://github.com/rails/rails/issues/32866
          Rails.application.routes.url_helpers.rails_blob_path(avatar, only_path: true)
        else
          list = self.class.image_files(race_info.key)
          file = list[(id || self.class.count.next).modulo(list.size)]
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

    concerning :MatchingMethods do
      included do
        scope :preset_scope, -> self_preset_key, oppo_preset_key { where(self_preset_key: self_preset_key).where(oppo_preset_key: oppo_preset_key) }
        scope :matching_scope, -> { online_only.where.not(matching_at: nil) } # オンラインのマッチング希望者
        scope :robot_only, -> { where(race_key: :robot) }
        scope :human_only, -> { where(race_key: :human) }
      end

      def setting_save(data)
        update!({
            lifetime_key:     data["lifetime_key"],
            platoon_key:      data["platoon_key"],
            self_preset_key:  data["self_preset_key"],
            oppo_preset_key:  data["oppo_preset_key"],
            robot_accept_key: data["robot_accept_key"],
          })
      end

      def matching_start(**options)
        options = {
          with_robot: (robot_accept_info.key == :accept),
        }.merge(options)

        update!(matching_at: Time.current) # マッチング対象にして待つ

        s = matching_scope

        if rule_cop.same_rule?
          s = s.merge(preset_reverse)
          rest = platoon_info.total_limit - s.count
          users = s.random_order.limit(platoon_info.total_limit)

          if options[:with_robot]
            # 人数に達っしていなければロボットで補完を試みる
            if rest >= 1
              robots = self.class.robot_only.random_order.limit(rest) # rest数取得できているとは限らない
              robots = robots.cycle.take(rest) # なので足りない部分は1人のボットが二役以上することになる
              users = users + robots
            end
          end

          # それでも人数に達っしていない場合は待つ
          if users.size < platoon_info.total_limit
            matching_wait_notify
            return
          end

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

      def battle_with(opponent)
        battle_setup([[self, opponent]], {battle_request_at: Time.current})
      end

      # 手合割を考慮して自分と相手の座席を決定する
      def seat_determination(opponent)
        a = [self, opponent]
        case
        when rule_cop.same_rule?
          if Rails.env.production?
            a = a.shuffle
          else
            # CPUを後手にするため
            a = a.reverse
          end
        when rule_cop.teacher?
          a = a.reverse
        end
        a
      end

      def matching_cancel
        update!(matching_at: nil)
      end

      private

      # class method or battle のインスタンスにする
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
          if user.race_info.auto_iku
            user.room_in(battle)
          else
            ActionCable.server.broadcast("single_notification_#{user.id}", {matching_establish: true, battle_show_path: battle.show_path}.merge(attributes))
          end
        end

        # 最初の手番がCPUなら指す。しかしここで動かしてしまうと音がでない。なので battle.js のトリガーで指すようにした。
        # battle.next_run_if_robot

        battle
      end

      def battle_create(attributes = {})
        Battle.create! do |e|
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
        s = self.class.matching_scope
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
        RuleCop.new(self_preset_key, oppo_preset_key)
      end

      class RuleCop
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

    concerning :BattleMethods do
      included do
        has_many :memberships, dependent: :destroy
        has_many :battles, through: :memberships
        belongs_to :current_battle, class_name: "Battle", optional: true, counter_cache: :current_users_count # 今入っている部屋

        has_many :watch_ships, dependent: :destroy                    # 自分が観戦している部屋たち(中間情報)
        has_many :watch_rooms, through: :watch_ships, source: :battle # 自分が観戦している部屋たち
      end

      # 今参加している対局
      def active_battles
        battles.merge(Membership.where.not(fighting_at: nil))
      end

      def room_in(battle)
        chat_say(battle, "入室しました", msg_class: "has-text-info")

        memberships ||= battle.memberships.where(user: self)

        # 自分から部屋に入ったらマッチングを解除する
        update!(matching_at: nil)

        # どの部屋にいるか設定
        update!(current_battle: battle) # FIXME: とる

        # 部屋のメンバーとして登録(マッチング済みの場合はもう登録されている)
        # unless battle.users.include?(current_user)
        #   battle.users << current_user
        # end

        if memberships.present?
          # 対局者
          memberships.each do |e|
            e.update!(fighting_at: Time.current)
          end
        else
          # 観戦者
          if !battle.watch_users.include?(current_user)
            battle.watch_users << current_user
            battle.broadcast # counter_cache の watch_ships_count を反映させるため
          end
        end

        if battle.end_at
          # もう対局は終わっている
        else
          # 自分が対局者の場合
          if memberships.present?
            if memberships.all? { |e| e.standby_at }
              # 入り直した場合
            else
              # 新規の場合
              memberships.each { |e|
                e.update!(standby_at: Time.current)
              }
              if battle.memberships.standby_enable.count >= battle.memberships.count
                battle.battle_start
              end
            end
          end
        end

        battle.memberships_broadcast
      end

      def room_out(battle)
        chat_say(battle, "退室しました", msg_class: "has-text-info")

        memberships ||= battle.memberships.where(user: self)

        update!(current_battle_id: nil) # とる

        if memberships.present?
          # 対局者
          # 切断したときにの処理がここで書ける
          # TODO: 対局中なら、残っている方がポーリングを開始して、10秒間以内に戻らなかったら勝ちとしてあげる
          memberships.each do |e|
            e.update!(fighting_at: nil)
          end
        else
          # 観戦者
          battle.watch_users.destroy(current_user)
          # ActionCable.server.broadcast(channel_key, watch_users: battle.watch_users)
        end

        battle.memberships_broadcast
      end
    end
  end
end

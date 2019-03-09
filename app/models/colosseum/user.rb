# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザー (colosseum_users as Colosseum::User)
#
# |------------------------+--------------------------+-------------+---------------------+------+-------|
# | name                   | desc                     | type        | opts                | refs | index |
# |------------------------+--------------------------+-------------+---------------------+------+-------|
# | id                     | ID                       | integer(8)  | NOT NULL PK         |      |       |
# | key                    | Key                      | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                     | string(255) | NOT NULL            |      |       |
# | online_at              | オンラインになった日時   | datetime    |                     |      |       |
# | fighting_at            | 入室しているなら入室日時 | datetime    |                     |      |       |
# | matching_at            | マッチング中(開始日時)   | datetime    |                     |      |       |
# | cpu_brain_key          | CPUの思考タイプ          | string(255) |                     |      |       |
# | user_agent             | ブラウザ情報             | string(255) | NOT NULL            |      |       |
# | race_key               | 種族                     | string(255) | NOT NULL            |      | F     |
# | created_at             | 作成日時                 | datetime    | NOT NULL            |      |       |
# | updated_at             | 更新日時                 | datetime    | NOT NULL            |      |       |
# | email                  | メールアドレス           | string(255) | NOT NULL            |      | B!    |
# | encrypted_password     | Encrypted password       | string(255) | NOT NULL            |      |       |
# | reset_password_token   | Reset password token     | string(255) |                     |      | C!    |
# | reset_password_sent_at | Reset password sent at   | datetime    |                     |      |       |
# | remember_created_at    | Remember created at      | datetime    |                     |      |       |
# | sign_in_count          | Sign in count            | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | current_sign_in_at     | Current sign in at       | datetime    |                     |      |       |
# | last_sign_in_at        | Last sign in at          | datetime    |                     |      |       |
# | current_sign_in_ip     | Current sign in ip       | string(255) |                     |      |       |
# | last_sign_in_ip        | Last sign in ip          | string(255) |                     |      |       |
# | confirmation_token     | Confirmation token       | string(255) |                     |      | D!    |
# | confirmed_at           | Confirmed at             | datetime    |                     |      |       |
# | confirmation_sent_at   | Confirmation sent at     | datetime    |                     |      |       |
# | unconfirmed_email      | Unconfirmed email        | string(255) |                     |      |       |
# | failed_attempts        | Failed attempts          | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | unlock_token           | Unlock token             | string(255) |                     |      | E!    |
# | locked_at              | Locked at                | datetime    |                     |      |       |
# |------------------------+--------------------------+-------------+---------------------+------+-------|

module Colosseum
  CpuBrainInfo

  class User < ApplicationRecord
    concerning :BasicMethods do
      included do
        scope :random_order, -> { order(Arel.sql("rand()")) }

        before_validation on: :create do
          self.key ||= SecureRandom.hex
          self.user_agent ||= ""
          self.password ||= "password"

          if race_info.key == :human
            number = self.class.human_only.count.next
            self.name ||= "名無しの棋士#{number}号"
            default_emal = "#{key}@localhost"
          else
            number = self.class.robot_only.count.next
            self.name ||= "CPU#{number}号"
            default_emal = "cpu-#{key}@localhost"
          end
          self.email ||= default_emal

          if changes[:name] && name
            # 絵文字があると MySQL が死ぬ
            # Mysql2::Error: Incorrect string value: '\xF0\x9F\xA6\x90b' になる
            self.name = name.encode('EUC-JP', 'UTF-8', invalid: :replace, undef: :replace, replace: '(絵文字)').encode('UTF-8')
          end

          if Rails.env.development?
            self.online_at ||= Time.current
          end
        end

        after_create do
          if Rails.env.production? || Rails.env.test?
            UserMailer.user_created(self).deliver_now
          end

          SlackAgent.chat_post_message(key: "ユーザー登録", body: "#{name}: #{attributes.inspect}")
        end
      end

      class_methods do
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
              create!(rule_attributes: {team_key: "team_p2vs2"})
            end
          end
        end
      end

      def show_path
        Rails.application.routes.url_helpers.url_for([self, only_path: true])
      end
    end

    concerning :ChronicleMethods do
      included do
        has_many :chronicles, dependent: :destroy

        if Rails.env.development? && false
          after_create do
            rand(10).times do
              judge_add(JudgeInfo.keys.sample)
            end
          end
        end
      end

      def win_count
        chronicles.judge_eq(:win).count
      end

      def lose_count
        chronicles.judge_eq(:lose).count
      end

      def win_ratio
        if total_count.zero?
          return 0.0
        end
        win_count.fdiv(total_count).round(3)
      end

      def total_count
        win_count + lose_count
      end

      def judge_add(key)
        judge_info = JudgeInfo.fetch(key)
        chronicles.create!(judge_key: judge_info.key)
      end
    end

    concerning :ProfileMethods do
      included do
        has_one :profile, dependent: :destroy
        accepts_nested_attributes_for :profile
        delegate :begin_greeting_message, :end_greeting_message, to: :profile

        after_create do
          profile || create_profile
        end
      end
    end

    concerning :RuleMethods do
      included do
        has_one :rule, dependent: :destroy
        accepts_nested_attributes_for :rule

        delegate :self_preset_info, :oppo_preset_info, :lifetime_info, :team_info, :robot_accept_info, to: :rule
        delegate :self_preset_key, :oppo_preset_key, :lifetime_key, :team_key, :robot_accept_key,      to: :rule

        after_create do
          rule || create_rule
        end
      end
    end

    concerning :ChatMessageMethods do
      included do
        has_many :chat_messages, dependent: :destroy
      end

      def chat_say(battle, message, msg_options = {})
        chat_message = chat_messages.create!(battle: battle, message: message, msg_options: msg_options)
        ActionCable.server.broadcast(battle.channel_key, chat_message: ams_sr(chat_message))
      end
    end

    concerning :SysopMethods do
      class_methods do
        def sysop
          find_by(key: __method__) || create!(key: __method__, name: "運営", email: "#{__method__}@localhost")
        end
      end

      def sysop?
        key == "sysop"
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

      # user.lobby_chat_say("ログインしました", :msg_class => "has-text-info")
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
        scope :preset_scope,    -> self_preset_key, oppo_preset_key { joins(:rule).merge(Rule.where(self_preset_key: self_preset_key, oppo_preset_key: oppo_preset_key)) }
        scope :matching_scope,  -> { online_only.where.not(matching_at: nil) } # オンラインのマッチング希望者
        scope :same_rule_scope, -> e { joins(:rule).merge(Rule.same_rule_scope(e)) }

        scope :robot_only, -> { where(race_key: :robot) }
        scope :human_only, -> { where(race_key: :human) }

        scope :light_only, -> { where(key: CpuBrainInfo.light_only.collect(&:key)) }

        scope :with_robot_ok, -> { joins(:rule).merge(Rule.with_robot_ok) } # CPUと対戦してもよい人たち
        scope :with_robot_ng, -> { joins(:rule).merge(Rule.with_robot_ng) } # CPUと対戦したくない人たち
      end

      def setting_save(data)
        update!(rule_attributes: {
            lifetime_key:     data["lifetime_key"],
            team_key:         data["team_key"],
            self_preset_key:  data["self_preset_key"],
            oppo_preset_key:  data["oppo_preset_key"],
            robot_accept_key: data["robot_accept_key"],
          })
      end

      def matching_start(**options)
        options = {
          with_robot: false,
        }.merge(options)

        total = team_info.total_limit
        half = team_info.half_limit

        update!(matching_at: Time.current) # マッチング対象にして待つ

        s = matching_scope

        if options[:with_robot]
          s = s.with_robot_ok
        end

        if rule_cop.same_rule?
          s = s.merge(preset_reverse)
          users = s.random_order.limit(total)

          if options[:with_robot]
            # 人数に達っしていなければロボットで補完を試みる
            users += completion_robots(total - users.size)
          end

          # それでも人数に達っしていない場合は待つ
          if users.size < total
            matching_wait
            return
          end

          pair_list = users.each_slice(2).to_a
        else
          s1 = s.merge(preset_equal)   # 自分の味方を探す
          s2 = s.merge(preset_reverse) # 相手を探す

          users1 = s1.random_order.limit(half)
          users2 = s2.random_order.limit(half)

          if options[:with_robot]
            rest = total - (users1.size + users2.size)
            if rest >= 1
              robots = completion_robots(rest)

              users1 += robots.shift(half - users1.size)
              users2 += robots.shift(half - users2.size)
            end
          end

          if users1.size < half || users2.size < half
            matching_wait
            return
          end

          pair_list = users1.zip(users2)
        end

        battle_setup(pair_list, auto_matched_at: Time.current)
      end

      # 必ず count 数のロボットを得る。ただしロボットが１人もいない場合は空
      def completion_robots(count)
        s = self.class.robot_only.light_only
        robots = s.random_order.limit(count) # count 数取得できているとは限らない
        robots.cycle.take(count)             # なので足りない部分は1人のボットが二役以上することになる
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
          if user.race_info.auto_jump
            user.room_in(battle)
          else
            SingleNotificationChannel.broadcast_to(user, {matching_establish: true, battle_show_path: battle.show_path}.merge(attributes))
          end
        end

        # ここで battle.next_run_if_robot とすれば最初の手番がCPUなら指す
        # しかしここで動かしてしまうと音がでない
        # なので battle.js のトリガーで指すようにしている

        battle
      end

      def battle_create(attributes = {})
        Battle.create! do |e|
          e.lifetime_key = lifetime_key
          e.team_key     = team_key
          e.attributes   = [:black_preset_key, :white_preset_key].zip(rule_cop.to_a).to_h
          e.attributes   = attributes
          e.save!
        end
      end

      def matching_wait
        LobbyChannel.broadcast_to(self, {matching_wait: {matching_at: matching_at}})
      end

      def matching_scope
        self.class.matching_scope.same_rule_scope(self)
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

        has_many :watch_ships, dependent: :destroy                    # 自分が観戦している部屋たち(中間情報)
        has_many :watch_rooms, through: :watch_ships, source: :battle # 自分が観戦している部屋たち
      end

      # 今参加している対局
      def active_battles
        battles.merge(Membership.where.not(fighting_at: nil))
      end

      def room_in(battle)
        if battle.end_at
          # もう対局は終わっている
          return
        end

        chat_say(battle, "入室しました", msg_class: "has-text-info")

        memberships ||= battle.memberships.where(user: self)

        # 自分から部屋に入ったらマッチングを解除する
        update!(matching_at: nil)

        if memberships.present?
          # 対局者
          memberships.each do |e|
            e.update!(fighting_at: Time.current)
          end
        else
          # 観戦者
          if !battle.watch_users.include?(self)
            battle.watch_users << self
          end
        end

        # 自分が対局者の場合
        if memberships.present?
          if memberships.all? { |e| e.standby_at }
            # 入り直した場合
          else
            # 新規の場合
            memberships.each { |e|
              e.update!(standby_at: Time.current)
            }

            chat_say(battle, begin_greeting_message)

            if battle.memberships.standby_enable.count >= battle.memberships.count
              battle.battle_start
            end
          end
        end
      end

      def room_out(battle)
        chat_say(battle, "退室しました", msg_class: "has-text-info")

        memberships ||= battle.memberships.where(user: self)

        if memberships.present?
          # 対局者
          # 切断したときにの処理がここで書ける
          # TODO: 対局中なら、残っている方がポーリングを開始して、10秒間以内に戻らなかったら勝ちとしてあげる
          memberships.each do |e|
            e.update!(fighting_at: nil)
          end
        else
          # 観戦者
          battle.watch_users.destroy(self)
        end
      end
    end

    concerning :DeviseMethods do
      included do
        has_many :auth_infos, dependent: :destroy
        accepts_nested_attributes_for :auth_infos

        devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
        devise :omniauthable, omniauth_providers: [:google, :twitter, :github]
      end
    end
  end
end

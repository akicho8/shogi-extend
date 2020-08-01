# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザー (users as User)
#
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | name                   | desc                       | type        | opts                | refs | index |
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | id                     | ID                         | integer(8)  | NOT NULL PK         |      |       |
# | key                    | ユニークなハッシュ         | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                       | string(255) | NOT NULL            |      |       |
# | cpu_brain_key          | CPUの思考タイプ            | string(255) |                     |      |       |
# | user_agent             | User agent                 | string(255) | NOT NULL            |      |       |
# | race_key               | 種族                       | string(255) | NOT NULL            |      | F     |
# | created_at             | 作成日                     | datetime    | NOT NULL            |      |       |
# | updated_at             | 更新日                     | datetime    | NOT NULL            |      |       |
# | email                  | メールアドレス             | string(255) | NOT NULL            |      | B!    |
# | encrypted_password     | 暗号化パスワード           | string(255) | NOT NULL            |      |       |
# | reset_password_token   | Reset password token       | string(255) |                     |      | C!    |
# | reset_password_sent_at | パスワードリセット送信時刻 | datetime    |                     |      |       |
# | remember_created_at    | ログイン記憶時刻           | datetime    |                     |      |       |
# | sign_in_count          | ログイン回数               | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | current_sign_in_at     | 現在のログイン時刻         | datetime    |                     |      |       |
# | last_sign_in_at        | 最終ログイン時刻           | datetime    |                     |      |       |
# | current_sign_in_ip     | 現在のログインIPアドレス   | string(255) |                     |      |       |
# | last_sign_in_ip        | 最終ログインIPアドレス     | string(255) |                     |      |       |
# | confirmation_token     | パスワード確認用トークン   | string(255) |                     |      | D!    |
# | confirmed_at           | パスワード確認時刻         | datetime    |                     |      |       |
# | confirmation_sent_at   | パスワード確認送信時刻     | datetime    |                     |      |       |
# | unconfirmed_email      | 未確認Eメール              | string(255) |                     |      |       |
# | failed_attempts        | 失敗したログイン試行回数   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | unlock_token           | Unlock token               | string(255) |                     |      | E!    |
# | locked_at              | ロック時刻                 | datetime    |                     |      |       |
# |------------------------+----------------------------+-------------+---------------------+------+-------|

class User < ApplicationRecord
  include ::Actb::UserMod

  concerning :BasicMethods do
    included do
      scope :random_order, -> { order(Arel.sql("rand()")) }

      before_validation on: :create do
        self.key ||= SecureRandom.hex
        self.user_agent ||= ""

        if Rails.env.production? || Rails.env.staging?
          self.password ||= Devise.friendly_token(32)
        else
          self.password ||= "password"
        end

        if race_info.key == :human
          number = self.class.human_only.count.next
          self.name ||= "名無しの棋士#{number}号"
          default_emal = "#{key}@localhost"
        end

        if race_info.key == :robot
          number = self.class.robot_only.count.next
          self.name ||= "CPU#{number}号"
          default_emal = "shogi.extend+cpu-#{key}@gmail.com"
        end

        self.email ||= default_emal
      end

      with_options allow_blank: true do
        validates :name, length: 1..64
      end

      after_create_commit do
        if Rails.env.production? || Rails.env.staging?
          SlackAgent.message_send(key: "ユーザー登録", body: attributes.slice("id", "name"))
        end
      end
    end

    class_methods do
      def setup(options = {})
        super

        sysop
        bot

        CpuBrainInfo.each do |e|
          unless find_by(key: e.key)
            create!(key: e.key, name: e.name, race_key: :robot, cpu_brain_key: e.key)
          end
        end
      end
    end

    def show_path
      Rails.application.routes.url_helpers.url_for([self, only_path: true])
    end
  end

  concerning :FreeBattleMethods do
    included do
      has_many :free_battles, dependent: :destroy
    end
  end

  concerning :ProfileMethods do
    included do
      has_one :profile, dependent: :destroy, autosave: true
      accepts_nested_attributes_for :profile
      delegate :description, :twitter_key, to: :profile

      after_create do
        profile || create_profile
      end
    end
  end

  concerning :SysopMethods do
    class_methods do
      def sysop
        staff_user_factory(key: "sysop", name: "運営", email: AppConfig[:admin_email])
      end

      def bot
        staff_user_factory(key: "bot", name: "BOT", email: AppConfig[:bot_email], race_key: :robot)
      end

      def staff_user_factory(attributes)
        key = attributes[:key]
        if user = find_by(key: key)
          return user
        end
        user = create!(attributes.merge(password: Rails.application.credentials.sysop_password))
        user.permit_tag_list = "staff"
        user.save!
        user
      end
    end

    def sysop?
      key == "sysop"
    end

    def bot?
      key == "bot"
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

    def robot?
      race_info.key == :robot
    end

    def human?
      race_info.key == :human
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
    def avatar_path
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

  concerning :MatchingMethods do
    included do
      scope :robot_only, -> { where(race_key: :robot) }
      scope :human_only, -> { where(race_key: :human) }
    end
  end

  concerning :DeviseMethods do
    included do
      has_many :auth_infos, dependent: :destroy
      accepts_nested_attributes_for :auth_infos

      devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
      devise :omniauthable, omniauth_providers: [:google, :twitter, :github]
    end

    def provider_name
      if auth_info = auth_infos.first
        auth_info.provider
      else
        "？"
      end
    end

    def email_valid?
      if Rails.env.test?
        return true
      end

      !email_invalid?
    end

    def email_invalid?
      email.blank? || email.include?("@localhost")
    end
  end

  concerning :XyRerordMethods do
    included do
      # rails r "tp User.first.xy_records"
      has_many :xy_records, dependent: :destroy
    end
  end

  concerning :TagMethods do
    included do
      acts_as_taggable_on :permit_tags
    end
  end

  # rails r "User.sysop.mute_infos.create!(target_user: User.bot); tp MuteInfo; tp User.sysop.mute_users"
  # rails r "User.sysop.mute_users << User.bot; tp MuteInfo; tp User.sysop.mute_users; tp User.sysop.mute_user_ids"
  # rails r "User.sysop.mute_users.destroy(User.bot); tp MuteInfo"
  concerning :MuteInfoMod do
    included do
      has_many :mute_infos, dependent: :destroy # 自分がミュートした人たち(中間情報)
      has_many :reverse_mute_infos, class_name: "MuteInfo", foreign_key: :target_user_id, dependent: :destroy # 自分をミュートした人たち(中間情報)。定義しているのは外部キー制約があってもユーザー削除できるようにするためでもある
      has_many :mute_users, through: :mute_infos, source: :target_user  # 自分がミュートした人たち
      has_many :reverse_mute_users, through: :mute_infos, source: :user # 自分をミュートした人たち
    end
  end
end

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザー (colosseum_users as Colosseum::User)
#
# |------------------------+--------------------------+-------------+---------------------+------+-------|
# | name                   | desc                     | type        | opts                | refs | index |
# |------------------------+--------------------------+-------------+---------------------+------+-------|
# | id                     | ID                       | integer(8)  | NOT NULL PK         |      |       |
# | key                    | ユニークなハッシュ       | string(255) | NOT NULL            |      | A!    |
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
# | joined_at              | ロビーに入った日時       | datetime    |                     |      |       |
# |------------------------+--------------------------+-------------+---------------------+------+-------|

require "colosseum"

module Colosseum
  CpuBrainInfo

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
          else
            number = self.class.robot_only.count.next
            self.name ||= "CPU#{number}号"
            default_emal = "cpu-#{key}@localhost"
          end
          self.email ||= default_emal

          if Rails.env.development?
            self.joined_at ||= Time.current
          end
        end

        after_create do
          if Rails.env.production? || Rails.env.staging?
            UserMailer.user_created(self).deliver_now
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
              create!(key: e.key, name: "#{e.name}CPU", race_key: :robot, online_at: Time.current, joined_at: Time.current, cpu_brain_key: e.key)
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

    concerning :FreeBattleMethods do
      included do
        has_many :free_battles, foreign_key: :colosseum_user_id, dependent: :destroy
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

    concerning :SysopMethods do
      class_methods do
        def sysop
          find_by(key: "sysop") || create!(key: "sysop", name: "運営", email: "sysop@localhost", password: Rails.application.credentials.sysop_password)
        end
        def bot
          find_by(key: "bot") || create!(key: "bot", name: "BOT", email: "bot@localhost", race_key: :robot, password: Rails.application.credentials.sysop_password)
        end
        # def alice
        #   find_by(key: "alice") || create!(key: "alice", name: "alice", email: "alice@localhost", race_key: :robot, password: Rails.application.credentials.sysop_password)
        # end
        # def bob
        #   find_by(key: "bob") || create!(key: "bob", name: "bob", email: "bob@localhost", race_key: :robot, password: Rails.application.credentials.sysop_password)
        # end
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
    end
  end
end

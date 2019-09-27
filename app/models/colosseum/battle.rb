# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局 (colosseum_battles as Colosseum::Battle)
#
# |-------------------+----------------------------------------------+-------------+---------------------+------+-------|
# | name              | desc                                         | type        | opts                | refs | index |
# |-------------------+----------------------------------------------+-------------+---------------------+------+-------|
# | id                | ID                                           | integer(8)  | NOT NULL PK         |      |       |
# | black_preset_key  | ▲手合割                                     | string(255) | NOT NULL            |      |       |
# | white_preset_key  | △手合割                                     | string(255) | NOT NULL            |      |       |
# | lifetime_key      | 時間                                         | string(255) | NOT NULL            |      |       |
# | team_key          | 人数                                         | string(255) | NOT NULL            |      |       |
# | full_sfen         | USI形式棋譜                                  | text(65535) | NOT NULL            |      |       |
# | clock_counts      | 対局時計情報                                 | text(65535) | NOT NULL            |      |       |
# | countdown_flags   | 秒読み状態                                   | text(65535) | NOT NULL            |      |       |
# | turn_max          | 手番数                                       | integer(4)  | NOT NULL            |      |       |
# | battle_request_at | 対局申し込みによる成立日時                   | datetime    |                     |      |       |
# | auto_matched_at   | 自動マッチングによる成立日時                 | datetime    |                     |      |       |
# | begin_at          | メンバーたち部屋に入って対局開始になった日時 | datetime    |                     |      |       |
# | end_at            | バトル終了日時                               | datetime    |                     |      |       |
# | last_action_key   | 最後の状態                                   | string(255) |                     |      |       |
# | win_location_key  | 勝った方の先後                               | string(255) |                     |      |       |
# | memberships_count | 対局者総数                                   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | watch_ships_count | この部屋の観戦者数                           | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時                                     | datetime    | NOT NULL            |      |       |
# | updated_at        | 更新日時                                     | datetime    | NOT NULL            |      |       |
# |-------------------+----------------------------------------------+-------------+---------------------+------+-------|

module Colosseum
  class Battle < ApplicationRecord
    cattr_accessor(:yomiage_enable) { false }

    class << self
      def setup(options = {})
        super

        if Rails.env.development?
          users = User.all
          50.times do
            list = users.sample(4)
            battle = create!
            list.each do |e|
              battle.users << e
            end
            users.sample(2).each do |e|
              battle.watch_users << e
            end
            if rand(2).zero?
              battle.update!(begin_at: Time.current)
              if rand(2).zero?
                battle.update!(end_at: Time.current)
              end
            end
          end

          p count
        end
      end
    end

    scope :latest_list,             -> { order(updated_at: :desc).limit(50) }
    scope :latest_list_for_profile, -> { order(updated_at: :desc).limit(25) }
    scope :st_battle_now,           -> { where.not(begin_at: nil).where(end_at: nil) }

    serialize :clock_counts
    serialize :countdown_flags

    before_validation on: :create do
      self.black_preset_key ||= "平手"
      self.white_preset_key ||= "平手"
      self.lifetime_key     ||= :lifetime_m10
      self.team_key         ||= :team_p1vs1
      self.turn_max         ||= 0
      self.clock_counts     ||= {black: [], white: []}
      self.countdown_flags  ||= {black: false, white: false}
    end

    before_validation do
      if changes_to_save[:black_preset_key] || changes_to_save[:white_preset_key]
        if black_preset_key && white_preset_key
          mediator = Bioshogi::Mediator.new
          mediator.board.placement_from_hash(black: black_preset_key, white: white_preset_key)
          mediator.turn_info.handicap = handicap
          self.full_sfen = "position #{mediator.to_long_sfen}"
        end
      end
    end

    after_create do
      SlackAgent.message_send(key: "対局開始", body: long_name)
    end

    def name
      "##{id}"
    end

    def long_name
      "##{id} 対戦部屋 " + users.collect(&:name).join(" vs ")
    end

    def xstate_key
      if begin_at && end_at
        :st_done
      elsif begin_at
        :st_battle_now
      else
        :st_before
      end
    end

    def xstate_info
      XstateInfo.fetch(xstate_key)
    end

    def human_kifu_text
      info = Bioshogi::Parser.parse(full_sfen, typical_error_case: :embed)
      begin
        mediator = info.mediator
      rescue => error
        return error.message
      end
      if begin_at
        info.header["開始日時"] = begin_at.to_s(:csa_ymdhms)
      end
      if end_at
        info.header["終了日時"] = end_at.to_s(:csa_ymdhms)
      end
      if persisted?
        info.header["場所"] = Rails.application.routes.url_helpers.url_for([self, {only_path: false}.merge(ActionMailer::Base.default_url_options)])
      end
      info.names_set(names_hash)
      info.to_ki2
    end

    def show_path
      Rails.application.routes.url_helpers.url_for([self, only_path: true])
    end

    def handicap
      !(black_preset_key == "平手" && white_preset_key == "平手")
    end

    def names_hash
      memberships.group_by(&:location_key).transform_values { |a| a.collect { |e| e.user.name }.join("・") }.symbolize_keys
    end

    include LobbyMethods
    include BattleMethods
    include UserMethods
    include WatchShipMethods
    include ChatMessageMethods
    include ChronicleMethods
  end
end

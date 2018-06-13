# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局情報テーブル (general_battles as GeneralBattle)
#
# |--------------------------+-----------------+-------------+-------------+------+-------|
# | カラム名                 | 意味            | タイプ      | 属性        | 参照 | INDEX |
# |--------------------------+-----------------+-------------+-------------+------+-------|
# | id                       | ID              | integer(8)  | NOT NULL PK |      |       |
# | battle_key               | 対局キー        | string(255) | NOT NULL    |      | A!    |
# | battled_at               | 対局日          | datetime    |             |      |       |
# | kifu_body                | 棋譜内容        | text(65535) | NOT NULL    |      |       |
# | general_battle_state_key | 結果            | string(255) | NOT NULL    |      | B     |
# | turn_max                 | 手数            | integer(4)  | NOT NULL    |      |       |
# | meta_info                | 棋譜ヘッダー    | text(65535) | NOT NULL    |      |       |
# | mountain_url             | 将棋山脈URL     | string(255) |             |      |       |
# | last_accessd_at          | Last accessd at | datetime    | NOT NULL    |      |       |
# | created_at               | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at               | 更新日時        | datetime    | NOT NULL    |      |       |
# |--------------------------+-----------------+-------------+-------------+------+-------|

require "matrix"

class GeneralBattle < ApplicationRecord
  include ConvertMethods

  has_many :general_memberships, -> { order(:position) }, dependent: :destroy, inverse_of: :general_battle

  before_validation on: :create do
    self.last_accessd_at ||= Time.current
    self.battle_key ||= SecureRandom.hex
    self.kifu_body ||= ""
  end

  before_validation do
    if changes[:kifu_body]
      parser_exec
    end
  end

  with_options presence: true do
    validates :battle_key
    validates :battled_at
    validates :general_battle_state_key
  end

  with_options allow_blank: true do
    validates :battle_key, uniqueness: true
  end

  validate do
    if general_memberships.size != 2
      errors.add(:base, "対局者が2人いません : #{general_memberships.size}")
    end
  end

  def to_param
    battle_key
  end

  def general_wstate_info
    GeneralWstateInfo.fetch(general_battle_state_key)
  end

  concerning :ConvertHookMethos do
    class_methods do
      def kifu_dir_default
        if Rails.env.test?
          "."
        elsif Rails.env.development?
          "."
          # ".."
        else
          "/home/deploy"
        end
      end

      def import(key, **params)
        begin
          p [Time.current.to_s(:ymdhms), "begin", GeneralUser.count, GeneralBattle.count] unless Rails.env.test?
          public_send(key, params)
        rescue => error
          raise error
        ensure
          unless Rails.env.test?
            puts
            p [Time.current.to_s(:ymdhms), "end__", GeneralUser.count, GeneralBattle.count, error].compact
          end
        end
      end

      # rails r 'GeneralBattle.destroy_all; GeneralBattle.all_import'
      # capp rails:runner CODE='GeneralBattle.all_import'
      # rails r 'GeneralBattle.all_import(kifu_dir: "..")'
      def all_import(**params)
        params = {
          kifu_dir: kifu_dir_default,
        }.merge(params)

        files = Rails.root.join(params[:kifu_dir]).glob("2chkifu/**/*.{ki2,KI2}").sort
        if v = params[:range]
          files = files[v]
        end
        if v = params[:limit]
          files = files.take(v)
        end
        if v = params[:sample]
          files = files.sample(v)
        end
        if params[:reset]
          GeneralUser.destroy_all
          GeneralBattle.destroy_all
        end
        files.each do |file|
          basic_import(params.merge(file: file))
          STDOUT.flush
        end
      end

      def basic_import(**params)
        battle_key = params[:file].basename(".*").to_s
        record = find_or_initialize_by(battle_key: battle_key)
        record.kifu_body = params[:file].read.toutf8
        record.parser_exec
        if record.new_record?
          mark = "C"
        else
          if record.changed?
            mark = "U"
          else
            mark = "."
          end
        end
        unless Rails.env.test?
          print mark
        end

        record.save!
      end

      def old_record_destroy(**params)
        params = {
          time: 1.weeks.ago,
        }.merge(params)

        where(arel_table[:last_accessd_at].lteq(params[:time])).destroy_all
      end
    end

    def parser_exec_after(info)
      self.general_battle_state_key = info.last_action_info.key
      other_tag_list << general_wstate_info.name

      other_tag_list << battle_key

      meta_info[:simple_names].each do |pair|
        pair.each do |names|
          GeneralUser.find_or_create_by(name: names.first)
        end
      end

      if persisted?
        ships = general_memberships.order(:position)
      else
        ships = info.mediator.players.count.times.collect { general_memberships.build }
      end

      info.mediator.players.each.with_index do |player, i|
        judge_key = :draw
        unless general_wstate_info.draw
          judge_key = player.judge_key
        end

        general_membership = ships[i]
        general_membership.attributes = {
          judge_key: judge_key,
          location_key: player.location.key,
          defense_tag_list: player.skill_set.defense_infos.normalize.collect(&:key),
          attack_tag_list: player.skill_set.attack_infos.normalize.collect(&:key),
        }
      end
    end
  end

  concerning :HelperMethods do
    def win_lose_str(general_membership)
      if general_wstate_info.draw
        Fa.icon_tag(:fas, :minus, :class => "icon_hidden")
      else
        if general_membership.judge_key == "win"
          Fa.icon_tag(:far, :circle)
        elsif general_membership.judge_key == "lose"
          Fa.icon_tag(:fas, :times)
        else
          raise "must not happen"
        end
      end
    end

    def myself(user)
      index = meta_info[:simple_names].index { |e| e.flatten.include?(user.name) }
      general_memberships_of_index(index)
    end

    def rival(user)
      index = meta_info[:simple_names].index { |e| !e.flatten.include?(user.name) }
      general_memberships_of_index(index)
    end

    def general_memberships_of_index(index)
      general_memberships.includes(:taggings)[index]
    end
  end
end

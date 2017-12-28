# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle2_records as Battle2Record)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | カラム名          | 意味              | タイプ      | 属性        | 参照 | INDEX |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | battle_key        | Battle key        | string(255) | NOT NULL    |      | A!    |
# | battled_at        | Battled at        | datetime    |             |      |       |
# | kifu_body         | 棋譜内容          | text(65535) | NOT NULL    |      |       |
# | battle2_state_key | Battle2 state key | string(255) | NOT NULL    |      | B     |
# | turn_max          | 手数              | integer(4)  | NOT NULL    |      |       |
# | meta_info         | 棋譜ヘッダー      | text(65535) | NOT NULL    |      |       |
# | mountain_url      | 将棋山脈URL       | string(255) |             |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      |       |
# |-------------------+-------------------+-------------+-------------+------+-------|

require "matrix"

class Battle2Record < ApplicationRecord
  include ConvertMethods

  has_many :battle2_ships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle2_record

  before_validation do
    self.battle_key ||= SecureRandom.hex
    self.kifu_body ||= ""

    if changes[:kifu_body]
      parser_exec
    end
  end

  with_options presence: true do
    validates :battle_key
    validates :battled_at
    validates :battle2_state_key
  end

  with_options allow_blank: true do
    validates :battle_key, uniqueness: true
  end

  validate do
    if battle2_ships.size != 2
      errors.add(:base, "対局者が2人いません : #{battle2_ships.size}")
    end
  end

  def to_param
    battle_key
  end

  def battle2_state_info
    Battle2StateInfo.fetch(battle2_state_key)
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

      # rails r 'Battle2Record.destroy_all; Battle2Record.all_import'
      # capp rails:runner CODE='Battle2Record.all_import'
      # rails r 'Battle2Record.all_import(kifu_dir: "..")'
      def all_import(**params)
        params = {
          kifu_dir: kifu_dir_default,
        }.merge(params)

        files = Pathname.glob(Rails.root.join("#{params[:kifu_dir]}/2chkifu/**/*.{ki2,KI2}")).sort
        if v = params[:range]
          files = files[v]
        end
        if v = params[:limit]
          files = files.take(v)
        end
        if params[:reset]
          Battle2User.destroy_all
          Battle2Record.destroy_all
        end

        begin
          p [Time.current.to_s(:ymdhms), "begin", Battle2User.count, Battle2Record.count] unless Rails.env.test?
          files.each do |file|
            basic_import(params.merge(file: file))
            STDOUT.flush
          end
        rescue => error
          raise error
        ensure
          unless Rails.env.test?
            puts
            p [Time.current.to_s(:ymdhms), "end__", Battle2User.count, Battle2Record.count, error].compact
          end
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
    end

    def parser_exec_after(info)
      self.battle2_state_key = info.last_action_info.key
      other_tag_list << battle2_state_info.name

      other_tag_list << battle_key

      meta_info[:simple_names].each do |pair|
        pair.each do |names|
          Battle2User.find_or_create_by(name: names.first)
        end
      end

      if persisted?
        ships = battle2_ships.order(:position)
      else
        ships = info.mediator.players.count.times.collect { battle2_ships.build }
      end

      info.mediator.players.each.with_index do |player, i|
        judge_key = :draw
        unless battle2_state_info.draw
          judge_key = player.judge_key
        end

        battle2_ship = ships[i]
        battle2_ship.attributes = {
          judge_key: judge_key,
          location_key: player.location.key,
          defense_tag_list: player.skill_set.normalized_defense_infos.collect(&:key),
          attack_tag_list: player.skill_set.normalized_attack_infos.collect(&:key),
        }
      end
    end
  end

  concerning :HelperMethods do
    def win_lose_str(battle2_ship)
      if battle2_state_info.draw
        Fa.icon_tag(:minus, :class => "icon_hidden")
      else
        if battle2_ship.judge_key == "win"
          Fa.icon_tag(:circle_o)
        elsif battle2_ship.judge_key == "lose"
          Fa.icon_tag(:times)
        else
          raise "must not happen"
        end
      end
    end

    def myself(user)
      index = meta_info[:simple_names].index { |e| e.flatten.include?(user.name) }
      battle2_ships[index]
    end

    def rival(user)
      index = meta_info[:simple_names].index { |e| !e.flatten.include?(user.name) }
      battle2_ships[index]
    end
  end
end

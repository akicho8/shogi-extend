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
# | battled_at        | Battled at        | datetime    | NOT NULL    |      |       |
# | kifu_body         | 棋譜内容          | text(65535) | NOT NULL    |      |       |
# | battle2_state_key | Battle2 state key | string(255) | NOT NULL    |      | B     |
# | turn_max          | 手数              | integer(4)  | NOT NULL    |      |       |
# | kifu_header       | 棋譜ヘッダー      | text(65535) | NOT NULL    |      |       |
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
    included do
      # before_validation do
      #   if changes[:kifu_body]
      #     parser_exec
      #   end
      # end
    end

    class_methods do
      def kifu_dir
        if Rails.env.test?
          "."
        elsif Rails.env.development?
          "."
          # ".."
        else
          "/home/deploy"
        end
      end

      def kifu_files
        Pathname.glob(Rails.root.join("#{kifu_dir}/2chkifu/**/*.{ki2,KI2}")).sort
      end

      # rails r 'Battle2Record.destroy_all; Battle2Record.all_import'
      # capp rails:runner CODE='Battle2Record.all_import'
      def all_import(**params)
        begin
          files = kifu_files
          if v = params[:range]
            file = files[v]
          end
          p [Time.current.to_s(:ymdhms), "begin", Battle2User.count, Battle2Record.count] unless Rails.env.test?
          files.each do |file|
            basic_import(params.merge(file: file))
            STDOUT.flush
          end
        rescue => error
          puts file
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
      self.other_tag_list = []
      self.battle2_state_key = info.last_action_info.key

      info.header.to_simple_names_h.values.flatten.each do |name|
        Battle2User.find_or_create_by(name: name)
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

        other_tag_list << battle_key
        other_tag_list << battle2_state_info.name
        other_tag_list << info.header["棋戦"]
        other_tag_list << info.header.to_kisen_a
        other_tag_list << info.header["持ち時間"]
        other_tag_list << info.header["掲載"]
        other_tag_list << info.header["備考"]
        other_tag_list << info.header.to_names_h.values.flatten
        other_tag_list << info.header.to_simple_names_h.values.flatten

        if v = info.header["場所"]
          if md = v.match(/(.*)「(.*?)」/)
            other_tag_list << md.captures
          else
            other_tag_list << v
          end
        end

        if v = info.header["開始日時"].presence
          other_tag_list << date_to_tags(v)

          if t = (Time.zone.parse(v) rescue nil)
            self.battled_at = t
          else
            values = v.scan(/\d+/).collect { |e|
              e = e.to_i
              if e.zero?
                e = 1
              end
              e
            }
            self.battled_at = Time.zone.local(*values)
          end
        else
          self.battled_at = Time.zone.parse("0001/01/01")
        end

        other_tag_list << turn_max
        other_tag_list << info.header["手合割"]

        other_tag_list << player.skill_set.normalized_defense_infos.collect(&:key)
        other_tag_list << player.skill_set.normalized_attack_infos.collect(&:key)
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
      index = kifu_header[:to_simple_names_h].values.index { |e| e.include?(user.name) }
      battle2_ships[index]
    end

    def rival(user)
      index = kifu_header[:to_simple_names_h].values.index { |e| e.include?(user.name) }
      battle2_ships.reverse[index]
    end
  end

  concerning :ImportMethods do
    class_methods do
    end
  end

  concerning :TagMethods do
    included do
      acts_as_ordered_taggable_on :defense_tags
      acts_as_ordered_taggable_on :attack_tags
      acts_as_ordered_taggable_on :other_tags
    end
  end
end

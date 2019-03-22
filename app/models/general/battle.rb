# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (general_battles as General::Battle)
#
# |-----------------+-----------------+-------------+-------------+------+-------|
# | name            | desc            | type        | opts        | refs | index |
# |-----------------+-----------------+-------------+-------------+------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |      |       |
# | key             | 対局キー        | string(255) | NOT NULL    |      | A!    |
# | battled_at      | 対局日          | datetime    |             |      |       |
# | kifu_body       | 棋譜内容        | text(65535) | NOT NULL    |      |       |
# | final_key       | 結果            | string(255) | NOT NULL    |      | B     |
# | turn_max        | 手数            | integer(4)  | NOT NULL    |      |       |
# | meta_info       | 棋譜ヘッダー    | text(65535) | NOT NULL    |      |       |
# | last_accessd_at | Last accessd at | datetime    | NOT NULL    |      |       |
# | created_at      | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |      |       |
# |-----------------+-----------------+-------------+-------------+------+-------|

require "matrix"

module General
  class Battle < ApplicationRecord
    include ConvertMethods

    has_many :memberships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle

    before_validation on: :create do
      self.last_accessd_at ||= Time.current
      self.key             ||= SecureRandom.hex
      self.kifu_body       ||= ""
    end

    before_validation do
      if changes[:kifu_body]
        parser_exec
      end
    end

    with_options presence: true do
      validates :key
      validates :battled_at
      validates :final_key
    end

    with_options allow_blank: true do
      validates :key, uniqueness: true
    end

    validate do
      if memberships.size != 2
        errors.add(:base, "対局者が2人いません。実際の人数:#{memberships.size}")
      end
    end

    def to_param
      key
    end

    def final_info
      FinalInfo.fetch(final_key)
    end

    concerning :ConvertHookMethos do
      class_methods do
        def setup(options = {})
          super

          if Rails.env.development?
            all_import(limit: 2)
            all_import
          end
        end

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
            p [Time.current.to_s(:ymdhms), "begin", User.count, Battle.count] unless Rails.env.test?
            public_send(key, params)
          rescue => error
            raise error
          ensure
            unless Rails.env.test?
              puts
              p [Time.current.to_s(:ymdhms), "end__", User.count, Battle.count, error].compact
            end
          end
        end

        # rails r 'Battle.destroy_all; Battle.all_import'
        # capp rails:runner CODE='Battle.all_import'
        # rails r 'Battle.all_import(kifu_dir: "..")'
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
            User.destroy_all
            Battle.destroy_all
          end
          files.each do |file|
            basic_import(params.merge(file: file))
            STDOUT.flush
          end
        end

        def basic_import(**params)
          key = params[:file].basename(".*").to_s
          record = find_or_initialize_by(key: key)
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
        self.final_key = info.last_action_info.key
        other_tag_list.add final_info.name

        other_tag_list.add key

        meta_info[:simple_names].each do |pair|
          pair.each do |names|
            User.find_or_create_by(name: names.first)
          end
        end

        if persisted?
          ships = memberships.order(:position)
        else
          ships = info.mediator.players.count.times.collect { memberships.build }
        end

        info.mediator.players.each.with_index do |player, i|
          judge_key = :draw
          unless final_info.draw
            judge_key = player.judge_key
          end

          membership = ships[i]
          membership.attributes = {
            judge_key: judge_key,
            location_key: player.location.key,
            defense_tag_list:   player.skill_set.defense_infos.normalize.collect(&:key),
            attack_tag_list:    player.skill_set.attack_infos.normalize.collect(&:key),
            technique_tag_list: player.skill_set.technique_infos.normalize.collect(&:key),
            note_tag_list:      player.skill_set.note_infos.normalize.collect(&:key),
          }
        end
      end
    end

    concerning :HelperMethods do
      def icon_html(membership)
        if final_info.draw
          Fa.icon_tag(:fas, :minus, :class => "icon_hidden")
        else
          if membership.judge_key == "win"
            Fa.icon_tag(:fas, :crown, class: :icon_o)
          elsif membership.judge_key == "lose"
            Fa.icon_tag(:fas, :times, class: :icon_x)
          else
            raise "must not happen"
          end
        end
      end

      def myself(user)
        index = meta_info[:simple_names].index { |e| e.flatten.include?(user.name) }
        memberships_of_index(index)
      end

      def rival(user)
        index = meta_info[:simple_names].index { |e| !e.flatten.include?(user.name) }
        memberships_of_index(index)
      end

      private

      def memberships_of_index(index)
        if index
          memberships.includes(:taggings)[index]
        end
      end
    end
  end
end

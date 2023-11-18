# -*- coding: utf-8 -*-
# == Schema Information ==
#
# League (tsl_leagues as Tsl::League)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | generation | Generation | integer(4) | NOT NULL    |      | A     |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# |------------+------------+------------+-------------+------+-------|

module Tsl
  class League < ApplicationRecord
    class << self
      def setup(options = {})
        Scraping.league_range.each do |generation|
          generation_update(generation, options)
        end
      end

      # rails r 'Tsl::League.generation_update(30)'
      def generation_update(generation, options = {})
        options = {
          :verbose => Rails.env.development? || Rails.env.staging? || Rails.env.production?,
        }.merge(options)

        if options[:verbose]
          tp({"三段リーグ取得": generation})
        end

        scraping = Scraping.new(options.merge(generation: generation))
        if scraping.user_infos.present?
          league = League.find_or_create_by!(generation: generation) # 1件でも記録があればその世代が存在するとする
          scraping.user_infos.each do |user_info|
            user = User.find_or_create_by!(name: user_info[:name])
            membership = league.memberships.find_by(user: user) || league.memberships.build(user: user)
            membership.update!(user_info.slice(:result_key, :start_pos, :ox, :age, :win, :lose))
          end
        end
      end
    end

    has_many :memberships, dependent: :destroy, inverse_of: :league
    has_many :users, through: :memberships

    scope :newest_order, -> { order(generation: :desc) }
    scope :oldest_order, -> { order(generation: :asc)  }

    def source_url
      Scraping.new(generation: generation).source_url
    end

    # 最新か？
    def newest_record?
      self.class.newest_order.first == self
    end
  end
end

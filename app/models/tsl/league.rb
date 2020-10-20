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
        Tsl::Scraping.league_range.each do |generation|
          generation_update(generation, options)
        end
      end

      # rails r 'Tsl::League.generation_update(30)'
      def generation_update(generation, options = {})
        tp({"三段リーグ取得": generation}) unless Rails.env.test?

        league = Tsl::League.find_or_create_by!(generation: generation)
        scraping = Tsl::Scraping.new(options.merge(generation: generation))

        Array(scraping.user_infos).each do |user_info|
          user = Tsl::User.find_or_create_by!(name: user_info[:name])
          membership = league.memberships.find_by(user: user) || league.memberships.build(user: user)
          membership.update!(user_info.slice(:result_key, :start_pos, :ox, :age, :win, :lose))
        end
      end
    end

    has_many :memberships, dependent: :destroy, inverse_of: :league
    has_many :users, through: :memberships

    scope :newest_order, -> { order(generation: :desc) }
    scope :oldest_order, -> { order(generation: :asc)  }

    def source_url
      Tsl::Scraping.new(generation: generation).source_url
    end
  end
end

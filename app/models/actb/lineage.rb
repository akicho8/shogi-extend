# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Lineage (actb_lineages as Actb::Lineage)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      |       |
# | position   | 順序               | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

module Actb
  class Lineage < ApplicationRecord
    class << self
      def setup(options = {})
        ::Actb::LineageInfo.each do |e|
          find_or_create_by!(key: e.key)
        end
      end

      def fetch(key)
        find_by!(key: key)
      end
    end

    acts_as_list top_of_list: 0
    default_scope { order(:position) }

    has_many :questions, dependent: :destroy

    with_options presence: true do
      validates :key
    end

    with_options allow_blank: true do
      validates :key, inclusion: LineageInfo.keys.collect(&:to_s)
    end

    def static_info
      LineageInfo.fetch(key)
    end
  end
end

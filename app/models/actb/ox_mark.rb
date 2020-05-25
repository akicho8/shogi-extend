# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Ans result (actb_ox_marks as Actb::OxMark)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      | A     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

module Actb
  class OxMark < ApplicationRecord
    class << self
      def setup(options = {})
        ::Actb::OxMarkInfo.each do |e|
          find_or_create_by!(key: e.key)
        end
      end

      def fetch(key)
        find_by!(key: key)
      end
    end

    def static_info
      OxMarkInfo.fetch(key)
    end
  end
end

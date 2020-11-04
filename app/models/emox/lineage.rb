# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Lineage (emox_lineages as Emox::Lineage)
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

module Emox
  class Lineage < ApplicationRecord
    include StaticMod

    has_many :questions, dependent: :destroy
  end
end

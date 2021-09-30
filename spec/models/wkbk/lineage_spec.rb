# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Lineage (wkbk_lineages as Wkbk::Lineage)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      | A!    |
# | position   | 順序               | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

require "rails_helper"

module Wkbk
  RSpec.describe Lineage, type: :model do
    include WkbkSupportMethods

    it do
      Wkbk::Lineage.all.collect(&:key) # => ["詰将棋", "実戦詰め筋", "手筋", "必死", "必死逃れ", "定跡", "秘密"]
      assert { Lineage.all.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.33905 seconds (files took 2.26 seconds to load)
# >> 1 example, 0 failures
# >> 

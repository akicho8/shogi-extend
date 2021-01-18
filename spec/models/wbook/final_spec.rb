# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Final (wbook_finals as Wbook::Final)
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

require 'rails_helper'

module Wbook
  RSpec.describe Final, type: :model do
    include WbookSupportMethods

    it do
      Wbook::Final.all.collect(&:key) # => ["f_give_up", "f_disconnect", "f_success", "f_pending"]
      assert { Final.all.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.34602 seconds (files took 2.16 seconds to load)
# >> 1 example, 0 failures
# >> 

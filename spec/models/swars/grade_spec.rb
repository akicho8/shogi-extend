# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Grade (swars_grades as Swars::Grade)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      | A!    |
# | priority   | Priority           | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

require 'rails_helper'

module Swars
  RSpec.describe Grade, type: :model do
    before do
      Swars.setup
    end

    it "name" do
      assert { Grade.find_by!(key: "十段").name == "十段" }
    end
  end
end

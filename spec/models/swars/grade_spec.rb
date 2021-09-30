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

require "rails_helper"

module Swars
  RSpec.describe Grade, type: :model do
    it "name" do
      assert { Grade.fetch("初段").name == "初段" }
    end

    it "priority" do
      assert { Grade.fetch("初段").priority == 9 }
    end

    it "relation" do
      grade = Grade.fetch("十段")
      user1 = User.create!(user_key: "user1", grade: Grade.fetch("十段"))
      user2 = User.create!(user_key: "user2", grade: Grade.fetch("初段"))
      battle = Battle.create_with_members!([user1, user2])
      assert { grade.memberships.collect(&:user_id) == [user1.id] }
      assert { grade.battles == [battle] }
      assert { Battle.where.not(id: grade.battles).count == 0 } # 十段を除外する例
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >> 
# >> Finished in 1.24 seconds (files took 4.61 seconds to load)
# >> 3 examples, 0 failures
# >> 

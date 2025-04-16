# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Grade (swars_grades as Swars::Grade)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | priority   | 優先度   | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

# == Swars::Schema Swars::Information ==
#
# Swars::Grade (swars_grades as Swars::Grade)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | priority   | 優先度   | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

require "rails_helper"

RSpec.describe Swars::Grade, type: :model, swars_spec: true do
  it "name" do
    assert { Swars::Grade.fetch("初段").name == "初段" }
  end

  it "priority" do
    assert { Swars::Grade.fetch("初段").priority == 9 }
  end

  it "relation" do
    grade = Swars::Grade.fetch("十段")
    user1 = Swars::User.create!(user_key: "user1", grade: Swars::Grade.fetch("十段"))
    user2 = Swars::User.create!(user_key: "user2", grade: Swars::Grade.fetch("初段"))
    battle = Swars::Battle.create_with_members!([user1, user2])
    assert { grade.memberships.collect(&:user_id) == [user1.id] }
    assert { grade.battles == [battle] }
    assert { Swars::Battle.where.not(id: grade.battles).count == 0 } # 十段を除外する例
  end

  it "10000級が存在する" do
    assert { Swars::Grade.fetch("10000級") }
  end
end
# >> Swars::Run options: exclude {:slow_spec=>true}
# >> ...
# >>
# >> Swars::Finished in 1.24 seconds (files took 4.61 seconds to load)
# >> 3 examples, 0 failures
# >>

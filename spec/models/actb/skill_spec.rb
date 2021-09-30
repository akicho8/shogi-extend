# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Skill (actb_skills as Actb::Skill)
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

require "rails_helper"

module Actb
  RSpec.describe Battle, type: :model do
    include ActbSupportMethods

    def test1(skill_key, skill_point, diff)
      user1.actb_main_xrecord.update!(skill: Skill.fetch(skill_key), skill_point: skill_point)
      user1.actb_main_xrecord.skill_add(diff)
      [user1.skill.key, user1.skill_point.to_i]
    end

    it do
      # 上昇
      assert { test1("C-",  98, 1)   == ["C-", 99] }
      assert { test1("C-",  98, 2)   == ["C",   0] }
      assert { test1("C-",  98, 3)   == ["C",   1] }
      # 上昇(飛び級)
      assert { test1("C-",  98, 101) == ["C",  99] }
      assert { test1("C-",  98, 102) == ["C+",  0] }
      assert { test1("C-",  98, 103) == ["C+",  1] }
      # 下降
      assert { test1("C+",  2, -1)   == ["C+",  1] }
      assert { test1("C+",  2, -2)   == ["C+",  0] }
      assert { test1("C+",  2, -3)   == ["C",  99] }
      # 下降(飛び級)
      assert { test1("C+",  2, -101) == ["C",   1] }
      assert { test1("C+",  2, -102) == ["C",   0] }
      assert { test1("C+",  2, -103) == ["C-", 99] }
      # 限界(上)
      assert { test1("X", 98, 1)     == ["X", 99] }
      assert { test1("X", 98, 2)     == ["X", 100] }
      assert { test1("X", 98, 3)     == ["X", 100] }
      # 限界(下)
      assert { test1("C-",  2, -1)   == ["C-",  1] }
      assert { test1("C-",  2, -2)   == ["C-",  0] }
      assert { test1("C-",  2, -3)   == ["C-",  0] }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 1.03 seconds (files took 2.67 seconds to load)
# >> 1 example, 0 failures
# >> 

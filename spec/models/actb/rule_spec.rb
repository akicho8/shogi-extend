# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Rule (actb_rules as Actb::Rule)
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
  RSpec.describe Rule, type: :model do
    include ActbSupportMethods

    it "class_methods" do
      Actb::Rule.all.collect(&:key) # => ["test_rule", "good_rule", "good_marathon_rule", "beginner_rule", "normal_rule", "pro_rule", "latest_rule", "technical_rule", "singleton_rule", "marathon_rule", "hybrid_rule", "classic_only_rule", "ahiru_only_rule"]
      assert { Rule.all.count >= 1 }
    end

    it "works" do
      rule = Actb::Rule.first

      rule.matching_users_add(user1)      # => true
      rule.matching_user_ids              # => [10]
      rule.matching_users_include?(user1) # => true
      rule.matching_users                 # => [#<User id: 10, key: "47f3f8e88a29e5223e7b63c2fd0810c6", name: "user1", cpu_brain_key: nil, user_agent: "", race_key: "human", created_at: "1999-12-31 15:00:00", updated_at: "1999-12-31 15:00:00", email: "user1@localhost", permit_tag_list: nil>]
      rule.matching_users_delete(user1)   # => true
      rule.matching_users                 # => []

      assert { rule.matching_users_add(user1)      == true       }
      assert { rule.matching_user_ids              == [user1.id] }
      assert { rule.matching_users_include?(user1) == true       }
      assert { rule.matching_users                 == [user1]    }
      assert { rule.matching_users_delete(user1)   == true       }
      assert { rule.matching_users                 == []         }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 1.44 seconds (files took 2.83 seconds to load)
# >> 2 examples, 0 failures
# >> 

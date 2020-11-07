# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Rule (emox_rules as Emox::Rule)
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

module Emox
  RSpec.describe Rule, type: :model do
    include EmoxSupportMethods

    it "class_methods" do
      Emox::Rule.all.collect(&:key) # => ["fischer_m3_p5_rule"]
      assert { Rule.all.count >= 1 }
    end

    it "works" do
      rule = Emox::Rule.first

      rule.matching_users_add(user1)      # => true
      rule.matching_user_ids              # => [145]
      rule.matching_users_include?(user1) # => true
      rule.matching_users                 # => [#<User id: 145, key: "1ea4db14c97bc2aba207472b180884fa", name: "user1", user_agent: "", race_key: "human", name_input_at: "1999-12-31 15:00:00", created_at: "1999-12-31 15:00:00", updated_at: "1999-12-31 15:00:00", email: "user1@localhost", permit_tag_list: nil>]
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
# >> Finished in 0.69392 seconds (files took 2.26 seconds to load)
# >> 2 examples, 0 failures
# >> 

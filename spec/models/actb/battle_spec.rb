# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (actb_battles as Actb::Battle)
#
# |--------------+--------------+------------+-------------+------+-------|
# | name         | desc         | type       | opts        | refs | index |
# |--------------+--------------+------------+-------------+------+-------|
# | id           | ID           | integer(8) | NOT NULL PK |      |       |
# | room_id      | Room         | integer(8) | NOT NULL    |      | A     |
# | parent_id    | Parent       | integer(8) |             |      | B     |
# | rule_id      | Rule         | integer(8) | NOT NULL    |      | C     |
# | final_id     | Final        | integer(8) | NOT NULL    |      | D     |
# | begin_at     | Begin at     | datetime   | NOT NULL    |      | E     |
# | end_at       | End at       | datetime   |             |      | F     |
# | rensen_index | Rensen index | integer(4) | NOT NULL    |      | G     |
# | created_at   | 作成日時     | datetime   | NOT NULL    |      |       |
# | updated_at   | 更新日時     | datetime   | NOT NULL    |      |       |
# |--------------+--------------+------------+-------------+------+-------|

require 'rails_helper'

module Actb
  RSpec.describe Battle, type: :model do
    include ActbSupportMethods

    it "final_keyをセットしたタイミングで終了時刻も設定" do
      battle1.update!(final: Actb::Final.fetch(:f_success))
      assert { battle1.end_at }
    end

    it "続きのバトル作成" do
      new_battle = battle1.onaji_heya_wo_atarasiku_tukuruyo
      assert { new_battle.kind_of?(Actb::Battle) }
      assert { new_battle.rensen_index == 1 }
    end

    describe "出題" do
      before do
        question1
      end

      it do
        assert { battle1.best_questions.size >= 1 }
      end
    end

    describe "#katimake_set" do
      def test(judge_key)
        users = 2.times.collect { User.create! }
        room = Actb::Room.create_with_members!(users, rule: Actb::Rule.fetch(:marathon_rule))
        battle = room.battle_create_with_members!
        battle.katimake_set(battle.users[0], judge_key, :f_success)
        battle.reload.memberships.flat_map do |e|
          [e.judge_info.key, e.user.rating, e.user.udemae.key, e.user.udemae_point]
        end
      end

      it "勝ち負け" do
        assert { test(:win)  == [:win,  1516, "C-", 20, :lose, 1484, "C-",  0] }
        assert { test(:lose) == [:lose, 1484, "C-",  0, :win,  1516, "C-", 20] }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...F
# >> 
# >> Failures:
# >> 
# >>   1) Actb::Battle#katimake_set 勝ち負け
# >>      Failure/Error: sdiff = diff * judge.pure_info.value_sign
# >> 
# >>      NoMethodError:
# >>        undefined method `value_sign' for #<Actb::JudgeInfo:0x00007fd9baeb26c0>
# >>      # ./app/models/actb/battle_katimake_set.rb:26:in `block (3 levels) in run'
# >>      # ./app/models/actb/battle_katimake_set.rb:24:in `each'
# >>      # ./app/models/actb/battle_katimake_set.rb:24:in `block (2 levels) in run'
# >>      # ./app/models/actb/battle_katimake_set.rb:20:in `each'
# >>      # ./app/models/actb/battle_katimake_set.rb:20:in `block in run'
# >>      # ./app/models/actb/battle_katimake_set.rb:14:in `run'
# >>      # ./app/models/actb/battle.rb:93:in `katimake_set'
# >>      # -:53:in `test'
# >>      # -:60:in `block (4 levels) in <module:Actb>'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # -:60:in `block (3 levels) in <module:Actb>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (2 levels) in <main>'
# >> 
# >> Finished in 1.37 seconds (files took 2.49 seconds to load)
# >> 4 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:59 # Actb::Battle#katimake_set 勝ち負け
# >> 

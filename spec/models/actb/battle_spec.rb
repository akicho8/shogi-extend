# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (actb_battles as Actb::Battle)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | room_id    | Room       | integer(8) | NOT NULL    |      | A     |
# | parent_id  | Parent     | integer(8) |             |      | B     |
# | rule_id    | Rule       | integer(8) | NOT NULL    |      | C     |
# | final_id   | Final      | integer(8) | NOT NULL    |      | D     |
# | begin_at   | Begin at   | datetime   | NOT NULL    |      | E     |
# | end_at     | End at     | datetime   |             |      | F     |
# | battle_pos | Battle pos | integer(4) | NOT NULL    |      | G     |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# | practice   | Practice   | boolean    |             |      |       |
# |------------+------------+------------+-------------+------+-------|

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
      assert { new_battle.battle_pos == 1 }
    end

    describe "出題" do
      before do
        question1
      end

      it do
        assert { battle1.best_questions.size >= 1 }
      end
    end

    describe "#judge_final_set" do
      def test(judge_key)
        users = 2.times.collect { User.create! }
        room = Actb::Room.create_with_members!(users, rule: Actb::Rule.fetch(:marathon_rule))
        battle = room.battle_create_with_members!
        battle.judge_final_set(battle.users[0], judge_key, :f_success)
        battle.reload.memberships.flat_map do |e|
          [e.judge_info.key, e.user.rating, e.user.skill.key, e.user.skill_point]
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
# >> ....
# >> 
# >> Finished in 1.9 seconds (files took 2.93 seconds to load)
# >> 4 examples, 0 failures
# >> 

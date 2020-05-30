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
    before(:context) do
      Actb.setup
    end

    let_it_be(:user1) { Colosseum::User.create! }
    let_it_be(:user2) { Colosseum::User.create! }

    let_it_be(:room) do
      Actb::Room.create_with_members!([user1, user2], rule: Rule.fetch(:marathon_rule))
    end

    let(:current_battle) do
      room.battle_create_with_members!
    end

    it "final_keyをセットしたタイミングで終了時刻も設定" do
      current_battle.update!(final: Actb::Final.fetch(:f_success))
      assert { current_battle.end_at }
    end

    describe "#best_questions" do
      it do
        assert { current_battle.best_questions }
      end
    end

    describe "#katimashita" do
      def test(judge_key)
        users = 2.times.collect { Colosseum::User.create! }
        room = Actb::Room.create_with_members!(users, rule: Actb::Rule.fetch(:marathon_rule))
        battle = room.battle_create_with_members!
        battle.katimashita(battle.users[0], judge_key, :f_success)
        battle.reload.memberships.flat_map do |e|
          [e.judge_info.key, e.user.rating]
        end
      end

      it "勝ち負け" do
        assert { test(:win)  == [:win,  1516, :lose, 1484] }
        assert { test(:lose) == [:lose, 1484, :win,  1516] }
      end
    end
  end
end

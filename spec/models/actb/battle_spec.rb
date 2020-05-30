# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (actb_battles as Actb::Battle)
#
# |--------------+--------------+-------------+-------------+------+-------|
# | name         | desc         | type        | opts        | refs | index |
# |--------------+--------------+-------------+-------------+------+-------|
# | id           | ID           | integer(8)  | NOT NULL PK |      |       |
# | room_id      | Room         | integer(8)  | NOT NULL    |      | A     |
# | parent_id    | Parent       | integer(8)  |             |      | B     |
# | begin_at     | Begin at     | datetime    | NOT NULL    |      | C     |
# | end_at       | End at       | datetime    |             |      | D     |
# | final_key    | Final key    | string(255) |             |      | E     |
# | rule_key     | Rule key     | string(255) | NOT NULL    |      | F     |
# | rensen_index | Rensen index | integer(4)  | NOT NULL    |      | G     |
# | created_at   | 作成日時     | datetime    | NOT NULL    |      |       |
# | updated_at   | 更新日時     | datetime    | NOT NULL    |      |       |
# |--------------+--------------+-------------+-------------+------+-------|

require 'rails_helper'

module Actb
  RSpec.describe Battle, type: :model do
    before(:context) do
      Actb.setup
    end

    let_it_be(:user1) { Colosseum::User.create! }
    let_it_be(:user2) { Colosseum::User.create! }

    let_it_be(:room) do
      Actb::Room.create_with_members!([user1, user2], rule_key: :marathon_rule)
    end

    let(:current_battle) do
      room.battle_create_with_members!
    end

    it "final_keyをセットしたタイミングで終了時刻も設定" do
      current_battle.update!(final_key: :all_clear)
      assert { current_battle.end_at }
    end

    describe "#best_questions" do
      it do
        assert { battle.best_questions }
      end
    end

    describe "#katimashita" do
      def test(judge_key)
        users = 2.times.collect { Colosseum::User.create! }
        room = Actb::Room.create_with_members!(users, rule_key: :marathon_rule)
        battle = room.battle_create_with_members!
        battle.katimashita(battle.users[0], judge_key, :all_clear)
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

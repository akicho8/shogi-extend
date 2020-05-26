# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle message (actb_room_messages as Actb::RoomMessage)
#
# |------------+----------+-------------+-------------+-----------------------+-------|
# | name       | desc     | type        | opts        | refs                  | index |
# |------------+----------+-------------+-------------+-----------------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |                       |       |
# | user_id    | User     | integer(8)  |             | => Colosseum::User#id | A     |
# | battle_id    | Battle     | integer(8)  |             |                       | B     |
# | body       | 内容     | string(512) |             |                       |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |                       |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |                       |       |
# |------------+----------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_profile
#--------------------------------------------------------------------------------

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

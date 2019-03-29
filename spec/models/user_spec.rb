# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (users as Colosseum::User)
#
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | カラム名               | 意味                | タイプ      | 属性        | 参照             | INDEX |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | id                     | ID                  | integer(8)  | NOT NULL PK |                  |       |
# | name                   | 名前                | string(255) | NOT NULL    |                  |       |
# | current_battle_id | Current battle room | integer(8)  |             | => Colosseum::Battle#id | A     |
# | online_at              | Online at           | datetime    |             |                  |       |
# | fighting_at            | Fighting at         | datetime    |             |                  |       |
# | matching_at            | Matching at         | datetime    |             |                  |       |
# | lifetime_key           | Lifetime key        | string(255) | NOT NULL    |                  | B     |
# | team_key            | Team key         | string(255) | NOT NULL    |                  | C     |
# | self_preset_key        | Self preset key     | string(255) | NOT NULL    |                  | D     |
# | oppo_preset_key        | Oppo preset key     | string(255) | NOT NULL    |                  | E     |
# | user_agent             | Colosseum::User agent          | string(255) | NOT NULL    |                  |       |
# | created_at             | 作成日時            | datetime    | NOT NULL    |                  |       |
# | updated_at             | 更新日時            | datetime    | NOT NULL    |                  |       |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・User モデルは Colosseum::Battle モデルから has_many :current_users, :foreign_key => :current_battle_id されています。
#--------------------------------------------------------------------------------

require 'rails_helper'

module Colosseum
  RSpec.describe User, type: :model do
    context "対戦リクエスト" do
      it "自分vs自分" do
        @user1 = create_user(:team_p4vs4, "平手", "平手")
        battle = @user1.battle_with(@user1)
        assert { battle }
        assert { battle.black_preset_key == "平手" }
        assert { battle.white_preset_key == "平手" }
        assert { battle.users.sort == [@user1, @user1] }

        assert { battle.battle_request_at }
        assert { battle.auto_matched_at == nil }
      end

      it "平手" do
        @user1 = create_user(:team_p4vs4, "平手", "平手")
        @user2 = create_user(:team_p4vs4, "平手", "二枚落ち")

        battle = @user1.battle_with(@user2)
        assert { battle }
        assert { battle.black_preset_key == "平手" }
        assert { battle.white_preset_key == "平手" }
        assert { battle.users.sort == [@user1, @user2] }
      end

      it "駒落ち" do
        @user1 = create_user(:team_p4vs4, "二枚落ち", "平手")
        @user2 = create_user(:team_p4vs4, "平手", "平手")

        battle = @user1.battle_with(@user2)
        assert { battle }
        assert { battle.black_preset_key == "平手" }
        assert { battle.white_preset_key == "二枚落ち" }
        assert { battle.memberships.black.collect(&:user).sort == [@user2] }
        assert { battle.memberships.white.collect(&:user).sort == [@user1] }
      end

      it "両方駒落ち" do
        @user1 = create_user(:team_p4vs4, "二枚落ち", "香落ち")
        @user2 = create_user(:team_p4vs4, "平手", "平手")

        battle = @user1.battle_with(@user2)
        assert { battle }
        assert { battle.black_preset_key == "香落ち" }
        assert { battle.white_preset_key == "二枚落ち" }
        assert { battle.memberships.black.collect(&:user).sort == [@user2] }
        assert { battle.memberships.white.collect(&:user).sort == [@user1] }
      end
    end

    context "マッチング" do
      context "人間同士" do
        it "平手シングルス" do
          @user1 = create_user(:team_p1vs1, "平手", "平手")
          @user2 = create_user(:team_p1vs1, "平手", "平手")

          @user1.matching_start
          battle = @user2.matching_start
          assert { battle }
          assert { battle.users.sort == [@user1, @user2] }

          assert { battle.battle_request_at == nil }
          assert { battle.auto_matched_at }
        end

        it "平手ダブルス" do
          @user1 = create_user(:team_p2vs2, "平手", "平手")
          @user2 = create_user(:team_p2vs2, "平手", "平手")
          @user3 = create_user(:team_p2vs2, "平手", "平手")
          @user4 = create_user(:team_p2vs2, "平手", "平手")

          @user1.matching_start
          @user2.matching_start
          @user3.matching_start

          # 最後の1人
          battle = @user4.matching_start
          assert { battle }

          assert { [@user1, @user2, @user3, @user4].none? { |e| e.reload.matching_at } }
          assert { battle.users.sort == [@user1, @user2, @user3, @user4] }
        end

        it "駒落ちシングルス" do
          @user1 = create_user(:team_p1vs1, "平手", "飛車落ち")
          @user2 = create_user(:team_p1vs1, "飛車落ち", "平手")

          @user1.matching_start
          battle = @user2.matching_start
          assert { battle }
        end

        it "全員同じ駒落ちでのシングルス" do
          @user1 = create_user(:team_p1vs1, "飛車落ち", "飛車落ち")
          @user2 = create_user(:team_p1vs1, "飛車落ち", "飛車落ち")

          @user1.matching_start
          battle = @user2.matching_start

          assert { battle }
          assert { battle.users.sort == [@user1, @user2] }
        end

        it "駒落ちダブルス" do
          @user1 = create_user(:team_p2vs2, "平手", "飛車落ち")
          @user2 = create_user(:team_p2vs2, "平手", "飛車落ち")
          @user3 = create_user(:team_p2vs2, "飛車落ち", "平手")
          @user4 = create_user(:team_p2vs2, "飛車落ち", "平手")

          @user1.matching_start
          @user2.matching_start
          @user3.matching_start

          battle = @user4.matching_start

          assert { battle }
          assert { battle.memberships.black.collect(&:user).sort == [@user1, @user2] }
          assert { battle.memberships.white.collect(&:user).sort == [@user3, @user4] }
        end
      end

      context "人間vsロボット" do
        it "平手ダブルス" do
          @user0 = create_user(:team_p2vs2, "平手", "平手", :not_accept)
          @user1 = create_user(:team_p2vs2, "平手", "平手", :accept)
          @user2 = create_user(:team_p2vs2, "平手", "平手", :accept)
          @user3 = create_robot

          assert { @user0.matching_start == nil }
          assert { @user1.matching_start == nil }
          assert { @user2.matching_start == nil }

          battle = @user1.matching_start(with_robot: true)

          assert { battle }
          assert { battle.memberships.count == 4 }

          assert { battle.users.collect(&:name).sort == ["CPU1号", "CPU1号", "名無しの棋士2号", "名無しの棋士3号"] }
        end

        it "駒落ちダブルス" do
          @user0 = create_user(:team_p2vs2, "平手", "飛車落ち", :not_accept)
          @user1 = create_user(:team_p2vs2, "平手", "飛車落ち", :accept)
          @user2 = create_user(:team_p2vs2, "飛車落ち", "平手", :accept)
          @user3 = create_robot

          assert { @user0.matching_start == nil }
          assert { @user1.matching_start == nil }
          assert { @user2.matching_start == nil }

          battle = @user1.matching_start(with_robot: true)

          assert { battle }
          assert { battle.memberships.count == 4 }

          assert { battle.users.collect(&:name).sort == ["CPU1号", "CPU1号", "名無しの棋士2号", "名無しの棋士3号"] }
        end
      end
    end

    it "最初に指した状態で始まるようにもできる" do
      alice = User.create!
      bob = User.create!(race_key: :robot)
      battle = alice.battle_with(bob)

      battle.next_run

      info = Bioshogi::Parser.parse(battle.full_sfen)
      assert { info.mediator.turn_info.turn_max == 1 }
    end

    def create_user(team_key, self_preset_key, oppo_preset_key, robot_accept_key = :not_accept)
      create(:colosseum_user, rule_attributes: {team_key: team_key, self_preset_key: self_preset_key, oppo_preset_key: oppo_preset_key, robot_accept_key: robot_accept_key})
    end

    def create_robot
      create(:colosseum_user, {key: CpuBrainInfo.light_only.first.key, race_key: :robot})
    end
  end
end

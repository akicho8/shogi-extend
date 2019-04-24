# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザー (colosseum_users as Colosseum::User)
#
# |------------------------+--------------------------+-------------+---------------------+------+-------|
# | name                   | desc                     | type        | opts                | refs | index |
# |------------------------+--------------------------+-------------+---------------------+------+-------|
# | id                     | ID                       | integer(8)  | NOT NULL PK         |      |       |
# | key                    | Key                      | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                     | string(255) | NOT NULL            |      |       |
# | online_at              | オンラインになった日時   | datetime    |                     |      |       |
# | fighting_at            | 入室しているなら入室日時 | datetime    |                     |      |       |
# | matching_at            | マッチング中(開始日時)   | datetime    |                     |      |       |
# | cpu_brain_key          | CPUの思考タイプ          | string(255) |                     |      |       |
# | user_agent             | ブラウザ情報             | string(255) | NOT NULL            |      |       |
# | race_key               | 種族                     | string(255) | NOT NULL            |      | F     |
# | created_at             | 作成日時                 | datetime    | NOT NULL            |      |       |
# | updated_at             | 更新日時                 | datetime    | NOT NULL            |      |       |
# | email                  | メールアドレス           | string(255) | NOT NULL            |      | B!    |
# | encrypted_password     | Encrypted password       | string(255) | NOT NULL            |      |       |
# | reset_password_token   | Reset password token     | string(255) |                     |      | C!    |
# | reset_password_sent_at | Reset password sent at   | datetime    |                     |      |       |
# | remember_created_at    | Remember created at      | datetime    |                     |      |       |
# | sign_in_count          | Sign in count            | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | current_sign_in_at     | Current sign in at       | datetime    |                     |      |       |
# | last_sign_in_at        | Last sign in at          | datetime    |                     |      |       |
# | current_sign_in_ip     | Current sign in ip       | string(255) |                     |      |       |
# | last_sign_in_ip        | Last sign in ip          | string(255) |                     |      |       |
# | confirmation_token     | Confirmation token       | string(255) |                     |      | D!    |
# | confirmed_at           | Confirmed at             | datetime    |                     |      |       |
# | confirmation_sent_at   | Confirmation sent at     | datetime    |                     |      |       |
# | unconfirmed_email      | Unconfirmed email        | string(255) |                     |      |       |
# | failed_attempts        | Failed attempts          | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | unlock_token           | Unlock token             | string(255) |                     |      | E!    |
# | locked_at              | Locked at                | datetime    |                     |      |       |
# |------------------------+--------------------------+-------------+---------------------+------+-------|

require 'rails_helper'

module Colosseum
  RSpec.describe User, type: :model do
    context "リレーション" do
      user = User.create!
      assert { user.free_battles.to_a }
      user.destroy!
    end

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

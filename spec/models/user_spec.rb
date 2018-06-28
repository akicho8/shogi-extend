# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (users as Fanta::User)
#
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | カラム名               | 意味                | タイプ      | 属性        | 参照             | INDEX |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | id                     | ID                  | integer(8)  | NOT NULL PK |                  |       |
# | name                   | 名前                | string(255) | NOT NULL    |                  |       |
# | current_battle_id | Current battle room | integer(8)  |             | => Fanta::Battle#id | A     |
# | online_at              | Online at           | datetime    |             |                  |       |
# | fighting_at            | Fighting at         | datetime    |             |                  |       |
# | matching_at            | Matching at         | datetime    |             |                  |       |
# | lifetime_key           | Lifetime key        | string(255) | NOT NULL    |                  | B     |
# | platoon_key            | Platoon key         | string(255) | NOT NULL    |                  | C     |
# | self_preset_key        | Self preset key     | string(255) | NOT NULL    |                  | D     |
# | oppo_preset_key        | Oppo preset key     | string(255) | NOT NULL    |                  | E     |
# | user_agent             | Fanta::User agent          | string(255) | NOT NULL    |                  |       |
# | created_at             | 作成日時            | datetime    | NOT NULL    |                  |       |
# | updated_at             | 更新日時            | datetime    | NOT NULL    |                  |       |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・User モデルは Fanta::Battle モデルから has_many :current_users, :foreign_key => :current_battle_id されています。
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe Fanta::User, type: :model do
  context "対戦リクエスト" do
    it "自分vs自分" do
      @user1 = create_user(:platoon_p4vs4, "平手", "平手")
      battle = @user1.battle_with(@user1)
      assert { battle }
      assert { battle.black_preset_key == "平手" }
      assert { battle.white_preset_key == "平手" }
      assert { battle.users.sort == [@user1, @user1] }

      assert { battle.battle_request_at }
      assert { battle.auto_matched_at == nil }
    end

    it "平手" do
      @user1 = create_user(:platoon_p4vs4, "平手", "平手")
      @user2 = create_user(:platoon_p4vs4, "平手", "二枚落ち")

      battle = @user1.battle_with(@user2)
      assert { battle }
      assert { battle.black_preset_key == "平手" }
      assert { battle.white_preset_key == "平手" }
      assert { battle.users.sort == [@user1, @user2] }
    end

    it "駒落ち" do
      @user1 = create_user(:platoon_p4vs4, "二枚落ち", "平手")
      @user2 = create_user(:platoon_p4vs4, "平手", "平手")

      battle = @user1.battle_with(@user2)
      assert { battle }
      assert { battle.black_preset_key == "平手" }
      assert { battle.white_preset_key == "二枚落ち" }
      assert { battle.memberships.black.collect(&:user) == [@user2] }
      assert { battle.memberships.white.collect(&:user) == [@user1] }
    end

    it "両方駒落ち" do
      @user1 = create_user(:platoon_p4vs4, "二枚落ち", "香落ち")
      @user2 = create_user(:platoon_p4vs4, "平手", "平手")

      battle = @user1.battle_with(@user2)
      assert { battle }
      assert { battle.black_preset_key == "香落ち" }
      assert { battle.white_preset_key == "二枚落ち" }
      assert { battle.memberships.black.collect(&:user) == [@user2] }
      assert { battle.memberships.white.collect(&:user) == [@user1] }
    end
  end

  context "マッチング" do
    it "平手シングルス" do
      @user1 = create_user(:platoon_p1vs1, "平手", "平手")
      @user2 = create_user(:platoon_p1vs1, "平手", "平手")

      @user1.matching_start
      battle = @user2.matching_start
      assert { battle }
      assert { battle.users.sort == [@user1, @user2] }

      assert { battle.battle_request_at == nil }
      assert { battle.auto_matched_at }
    end

    it "平手ダブルス" do
      @user1 = create_user(:platoon_p2vs2, "平手", "平手")
      @user2 = create_user(:platoon_p2vs2, "平手", "平手")
      @user3 = create_user(:platoon_p2vs2, "平手", "平手")
      @user4 = create_user(:platoon_p2vs2, "平手", "平手")

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
      @user1 = create_user(:platoon_p1vs1, "平手", "飛車落ち")
      @user2 = create_user(:platoon_p1vs1, "飛車落ち", "平手")

      @user1.matching_start
      battle = @user2.matching_start
      assert { battle }
    end

    it "全員同じ駒落ちでのシングルス" do
      @user1 = create_user(:platoon_p1vs1, "飛車落ち", "飛車落ち")
      @user2 = create_user(:platoon_p1vs1, "飛車落ち", "飛車落ち")

      @user1.matching_start
      battle = @user2.matching_start

      assert { battle }
      assert { battle.users.sort == [@user1, @user2] }
    end

    it "駒落ちダブルス" do
      @user1 = create_user(:platoon_p2vs2, "平手", "飛車落ち")
      @user2 = create_user(:platoon_p2vs2, "平手", "飛車落ち")
      @user3 = create_user(:platoon_p2vs2, "飛車落ち", "平手")
      @user4 = create_user(:platoon_p2vs2, "飛車落ち", "平手")

      @user1.matching_start
      @user2.matching_start
      @user3.matching_start

      battle = @user4.matching_start

      assert { battle }
      assert { battle.memberships.black.collect(&:user) == [@user1, @user2] }
      assert { battle.memberships.white.collect(&:user) == [@user3, @user4] }
    end
  end

  def create_user(platoon_key, self_preset_key, oppo_preset_key)
    create(:fanta_user, {platoon_key: platoon_key, self_preset_key: self_preset_key, oppo_preset_key: oppo_preset_key})
  end
end

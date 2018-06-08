# == Schema Information ==
#
# 棋譜変換テーブル (free_battle_records as FreeBattleRecord)
#
# |--------------+--------------------+-------------+-------------+------+-------|
# | カラム名     | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |--------------+--------------------+-------------+-------------+------+-------|
# | id           | ID                 | integer(8)  | NOT NULL PK |      |       |
# | unique_key   | ユニークなハッシュ | string(255) | NOT NULL    |      | A!    |
# | kifu_file    | 棋譜ファイル       | string(255) |             |      |       |
# | kifu_url     | 棋譜URL            | string(255) |             |      |       |
# | kifu_body    | 棋譜内容           | text(65535) | NOT NULL    |      |       |
# | turn_max     | 手数               | integer(4)  | NOT NULL    |      |       |
# | meta_info    | 棋譜ヘッダー       | text(65535) | NOT NULL    |      |       |
# | mountain_url | 将棋山脈URL        | string(255) |             |      |       |
# | battled_at   | Battled at         | datetime    | NOT NULL    |      |       |
# | created_at   | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at   | 更新日時           | datetime    | NOT NULL    |      |       |
# |--------------+--------------------+-------------+-------------+------+-------|

require 'rails_helper'

RSpec.describe User, type: :model do
  context "対戦リクエスト" do
    it "自分vs自分" do
      @user1 = create_user(:platoon_p4vs4, "平手", "平手")
      battle_room = @user1.battle_setup_with(@user1)
      _assert { battle_room }
      _assert { battle_room.black_preset_key == "平手" }
      _assert { battle_room.white_preset_key == "平手" }
      _assert { battle_room.users.sort == [@user1, @user1] }

      _assert { battle_room.battle_request_at }
      _assert { battle_room.auto_matched_at == nil }
    end

    it "平手" do
      @user1 = create_user(:platoon_p4vs4, "平手", "平手")
      @user2 = create_user(:platoon_p4vs4, "平手", "二枚落ち")

      battle_room = @user1.battle_setup_with(@user2)
      _assert { battle_room }
      _assert { battle_room.black_preset_key == "平手" }
      _assert { battle_room.white_preset_key == "平手" }
      _assert { battle_room.users.sort == [@user1, @user2] }
    end

    it "駒落ち" do
      @user1 = create_user(:platoon_p4vs4, "二枚落ち", "平手")
      @user2 = create_user(:platoon_p4vs4, "平手", "平手")

      battle_room = @user1.battle_setup_with(@user2)
      _assert { battle_room }
      _assert { battle_room.black_preset_key == "平手" }
      _assert { battle_room.white_preset_key == "二枚落ち" }
      _assert { battle_room.memberships.black.collect(&:user) == [@user2] }
      _assert { battle_room.memberships.white.collect(&:user) == [@user1] }
    end

    it "両方駒落ち" do
      @user1 = create_user(:platoon_p4vs4, "二枚落ち", "香落ち")
      @user2 = create_user(:platoon_p4vs4, "平手", "平手")

      battle_room = @user1.battle_setup_with(@user2)
      _assert { battle_room }
      _assert { battle_room.black_preset_key == "香落ち" }
      _assert { battle_room.white_preset_key == "二枚落ち" }
      _assert { battle_room.memberships.black.collect(&:user) == [@user2] }
      _assert { battle_room.memberships.white.collect(&:user) == [@user1] }
    end
  end

  context "マッチング" do
    it "平手シングルス" do
      @user1 = create_user(:platoon_p1vs1, "平手", "平手")
      @user2 = create_user(:platoon_p1vs1, "平手", "平手")

      @user1.matching_start
      battle_room = @user2.matching_start
      _assert { battle_room }
      _assert { battle_room.users.sort == [@user1, @user2] }

      _assert { battle_room.battle_request_at == nil }
      _assert { battle_room.auto_matched_at }
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
      battle_room = @user4.matching_start
      _assert { battle_room }

      _assert { [@user1, @user2, @user3, @user4].none? { |e| e.reload.matching_at } }
      _assert { battle_room.users.sort == [@user1, @user2, @user3, @user4] }
    end

    it "駒落ちシングルス" do
      @user1 = create_user(:platoon_p1vs1, "平手", "飛車落ち")
      @user2 = create_user(:platoon_p1vs1, "飛車落ち", "平手")

      @user1.matching_start
      battle_room = @user2.matching_start
      _assert { battle_room }
    end

    it "全員同じ駒落ちでのシングルス" do
      @user1 = create_user(:platoon_p1vs1, "飛車落ち", "飛車落ち")
      @user2 = create_user(:platoon_p1vs1, "飛車落ち", "飛車落ち")

      @user1.matching_start
      battle_room = @user2.matching_start

      _assert { battle_room }
      _assert { battle_room.users.sort == [@user1, @user2] }
    end

    it "駒落ちダブルス" do
      @user1 = create_user(:platoon_p2vs2, "平手", "飛車落ち")
      @user2 = create_user(:platoon_p2vs2, "平手", "飛車落ち")
      @user3 = create_user(:platoon_p2vs2, "飛車落ち", "平手")
      @user4 = create_user(:platoon_p2vs2, "飛車落ち", "平手")

      @user1.matching_start
      @user2.matching_start
      @user3.matching_start

      battle_room = @user4.matching_start

      _assert { battle_room }
      _assert { battle_room.memberships.black.collect(&:user) == [@user1, @user2] }
      _assert { battle_room.memberships.white.collect(&:user) == [@user3, @user4] }
    end
  end

  def create_user(platoon_key, self_preset_key, oppo_preset_key)
    create(:user, {platoon_key: platoon_key, self_preset_key: self_preset_key, oppo_preset_key: oppo_preset_key})
  end
end

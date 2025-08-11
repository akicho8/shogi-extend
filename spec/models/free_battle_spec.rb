# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+---------------+-------------+-------------+--------------+-------|
# | name          | desc          | type        | opts        | refs         | index |
# |---------------+---------------+-------------+-------------+--------------+-------|
# | id            | ID            | integer(8)  | NOT NULL PK |              |       |
# | key           | キー          | string(255) | NOT NULL    |              | A!    |
# | title         | タイトル      | string(255) |             |              |       |
# | kifu_body     | 棋譜          | text(65535) | NOT NULL    |              |       |
# | sfen_body     | SFEN形式棋譜  | text(65535) | NOT NULL    |              |       |
# | turn_max      | 手数          | integer(4)  | NOT NULL    |              | B     |
# | meta_info     | 棋譜ヘッダー  | text(65535) | NOT NULL    |              |       |
# | battled_at    | Battled at    | datetime    | NOT NULL    |              | C     |
# | use_key       | Use key       | string(255) | NOT NULL    |              | D     |
# | accessed_at   | 参照日時      | datetime    | NOT NULL    |              | E     |
# | user_id       | User          | integer(8)  |             | => User#id   | F     |
# | description   | 説明          | text(65535) | NOT NULL    |              |       |
# | sfen_hash     | Sfen hash     | string(255) | NOT NULL    |              |       |
# | start_turn    | 開始局面      | integer(4)  |             |              | G     |
# | critical_turn | 開戦          | integer(4)  |             |              | H     |
# | outbreak_turn | Outbreak turn | integer(4)  |             |              | I     |
# | image_turn    | OGP画像の局面 | integer(4)  |             |              |       |
# | created_at    | 作成日時      | datetime    | NOT NULL    |              |       |
# | updated_at    | 更新日時      | datetime    | NOT NULL    |              |       |
# | preset_id     | Preset        | integer(8)  |             | => Preset#id | J     |
# |---------------+---------------+-------------+-------------+--------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# User.has_one :profile
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe FreeBattle, type: :model do
  let :record do
    FreeBattle.create!
  end

  let :ki2_record do
    FreeBattle.create!(kifu_body: Pathname(__dir__).join("sample.ki2").read)
  end

  describe "空の棋譜と平手の棋譜のハッシュは同じなので同じIDになる" do
    it "works" do
      free_battle1 = FreeBattle.same_body_fetch(body: "")
      adapter_receiver = FreeBattle.same_body_fetch(body: "position #{Bioshogi::Sfen::STARTPOS_EXPANSION}")
      assert { free_battle1.id == adapter_receiver.id }
    end
  end

  describe "simple_versus_desc" do
    it "works" do
      free_battle = FreeBattle.same_body_fetch(body: "手合割：平手")
      assert { free_battle.simple_versus_desc == nil }
    end
    it "works" do
      free_battle = FreeBattle.same_body_fetch(body: "68銀")
      assert { free_battle.simple_versus_desc == "☗嬉野流 vs ☖その他" }
    end
    it "works" do
      free_battle = FreeBattle.same_body_fetch(body: "68銀 52玉 26歩 51玉 25歩 52玉 38銀 51玉 27銀")
      assert { free_battle.simple_versus_desc == "☗嬉野流 原始棒銀 vs ☖その他" }
    end
  end

  it "raw_sec_list" do
    assert { record.raw_sec_list(:black)     == [ 1, 5, 2]   }
    assert { record.raw_sec_list(:white)     == [ 3, 7]      }
    assert { ki2_record.raw_sec_list(:white) == [ 0, 0]      }
  end

  describe "Twitterカード" do
    describe "to_twitter_card_params" do
      it "works" do
        params = record.to_twitter_card_params
        assert { params[:title]       == "5手目"                            }
        assert { params[:url]         == nil                                }
        assert { params[:image].match?(/http.*png\?turn=5&viewpoint=black/) }
        assert { params[:description] == nil                                }
      end
    end

    it "adjust_turn" do
      assert { record.adjust_turn(-1) == 5 }
      assert { record.adjust_turn(6) == 5 }
      assert { record.adjust_turn(-9) == 0 }
    end

    it "turn" do
      assert { record.display_turn == 5 }
    end
  end

  describe "コメントが含まれるKIFはカラムから溢れるため除去する" do
    it "works" do
      record = FreeBattle.create!(kifu_body: "*A\n**B\n1 ５六歩(57)\n")
      assert { record.kifu_body == "1 ５六歩(57)\n" }
    end
  end

  describe "ぴよ将棋？の日付フォーマット読み取り" do
    it "works" do
      record = FreeBattle.create!(kifu_body: "開始日時：2020年02月07日(金) 20：36：15")
      assert { record.battled_at.to_s == "2020-02-07 20:36:15 +0900" }
    end
  end

  describe "駒落ち判定" do
    it "works" do
      record = FreeBattle.create!(kifu_body: "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
      assert { record.preset_info.key == :"角落ち" }
    end
  end

  describe "use_key" do
    def case1(use_key)
      double_pawn_sfen = "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e"
      record = FreeBattle.create!(kifu_body: double_pawn_sfen, use_key: use_key)
      record.turn_max
    end

    it "works" do
      assert { case1(:basic)      == 2 } # 二歩の手前で止っている
      assert { case1(:kiwi_lemon) == 3 } # 二歩を許可
    end
  end
end

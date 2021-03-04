# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+--------------------+-------------+-------------+------------+-------|
# | name          | desc               | type        | opts        | refs       | index |
# |---------------+--------------------+-------------+-------------+------------+-------|
# | id            | ID                 | integer(8)  | NOT NULL PK |            |       |
# | key           | ユニークなハッシュ | string(255) | NOT NULL    |            | A!    |
# | kifu_url      | 棋譜URL            | string(255) |             |            |       |
# | title         | タイトル           | string(255) |             |            |       |
# | kifu_body     | 棋譜               | text(65535) | NOT NULL    |            |       |
# | sfen_body     | SFEN形式棋譜       | text(65535) | NOT NULL    |            |       |
# | turn_max      | 手数               | integer(4)  | NOT NULL    |            | B     |
# | meta_info     | 棋譜ヘッダー       | text(65535) | NOT NULL    |            |       |
# | battled_at    | Battled at         | datetime    | NOT NULL    |            | C     |
# | use_key       | Use key            | string(255) | NOT NULL    |            | D     |
# | accessed_at   | Accessed at        | datetime    | NOT NULL    |            | E     |
# | user_id       | User               | integer(8)  |             | => User#id | F     |
# | preset_key    | Preset key         | string(255) | NOT NULL    |            | G     |
# | description   | 説明               | text(65535) | NOT NULL    |            |       |
# | sfen_hash     | Sfen hash          | string(255) | NOT NULL    |            |       |
# | start_turn    | 開始局面           | integer(4)  |             |            | H     |
# | critical_turn | 開戦               | integer(4)  |             |            | I     |
# | outbreak_turn | Outbreak turn      | integer(4)  |             |            | J     |
# | image_turn    | OGP画像の局面      | integer(4)  |             |            |       |
# | created_at    | 作成日時           | datetime    | NOT NULL    |            |       |
# | updated_at    | 更新日時           | datetime    | NOT NULL    |            |       |
# |---------------+--------------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe FreeBattle, type: :model do
  before do
  end

  let :record do
    FreeBattle.create!
  end

  let :ki2_record do
    FreeBattle.create!(kifu_body: Pathname(__dir__).join("sample.ki2").read)
  end

  it "simple_versus_desc" do
    free_battle = FreeBattle.same_body_fetch(body: "")
    assert { free_battle.simple_versus_desc == nil }

    free_battle = FreeBattle.same_body_fetch(body: "68銀")
    assert { free_battle.simple_versus_desc == "☗嬉野流 vs ☖その他" }

    free_battle = FreeBattle.same_body_fetch(body: "68銀 52玉 26歩 51玉 25歩 52玉 38銀 51玉 27銀")
    assert { free_battle.simple_versus_desc == "☗嬉野流 原始棒銀 vs ☖その他" }
  end

  it "raw_sec_list" do
    assert { record.raw_sec_list(:black)     == [ 1, 5, 2]   }
    assert { record.raw_sec_list(:white)     == [ 3, 7]      }
    assert { ki2_record.raw_sec_list(:white) == [ nil, nil]  }
  end

  it "time_chart_params" do
    assert { record.time_chart_params.has_key?(:datasets) }
    assert { ki2_record.time_chart_params.has_key?(:datasets) }
  end

  describe "Twitterカード" do
    describe "to_twitter_card_params" do
      let :value do
        record.to_twitter_card_params
      end
      it do
        assert { value[:title]       == "5手目"                                                      }
        assert { value[:url]         == nil                                                          }
        assert { value[:image]       == "http://0.0.0.0:3000/x/free_battle1.png?turn=5&viewpoint=black" }
        assert { value[:description] == nil                                                          }
      end
    end

    it "adjust_turn" do
      assert { record.adjust_turn(-1) == 5 }
      assert { record.adjust_turn( 6) == 5 }
      assert { record.adjust_turn(-9) == 0 }
    end

    it "turn" do
      assert { record.display_turn == 5 }
    end
  end

  describe "コメントが含まれるKIFはカラムから溢れるため除去する" do
    it do
      record = FreeBattle.create!(kifu_body: "*A\n**B\n1 ５六歩(57)\n")
      assert { record.kifu_body == "1 ５六歩(57)\n" }
    end
  end

  describe "ぴよ将棋？の日付フォーマット読み取り" do
    it do
      record = FreeBattle.create!(kifu_body: "開始日時：2020年02月07日(金) 20：36：15")
      assert { record.battled_at.to_s == "2020-02-07 20:36:15 +0900" }
    end
  end

  describe "駒落ち判定" do
    it do
      record = FreeBattle.create!(kifu_body: "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
      assert { record.preset_info.key == :"角落ち" }
    end
  end
end

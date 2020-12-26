# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+--------------------+----------------+-------------+------------+-------|
# | name          | desc               | type           | opts        | refs       | index |
# |---------------+--------------------+----------------+-------------+------------+-------|
# | id            | ID                 | integer(8)     | NOT NULL PK |            |       |
# | key           | ユニークなハッシュ | string(255)    | NOT NULL    |            | A!    |
# | kifu_url      | 棋譜URL            | string(255)    |             |            |       |
# | title         | タイトル           | string(255)    |             |            |       |
# | kifu_body     | 棋譜               | text(16777215) | NOT NULL    |            |       |
# | turn_max      | 手数               | integer(4)     | NOT NULL    |            | B     |
# | meta_info     | 棋譜ヘッダー       | text(65535)    | NOT NULL    |            |       |
# | battled_at    | Battled at         | datetime       | NOT NULL    |            | C     |
# | use_key       | Use key            | string(255)    | NOT NULL    |            | D     |
# | accessed_at   | Accessed at        | datetime       | NOT NULL    |            |       |
# | user_id       | User               | integer(8)     |             | => User#id | E     |
# | preset_key    | Preset key         | string(255)    | NOT NULL    |            | F     |
# | description   | 説明               | text(65535)    | NOT NULL    |            |       |
# | sfen_body     | SFEN形式棋譜       | string(8192)   | NOT NULL    |            |       |
# | sfen_hash     | Sfen hash          | string(255)    | NOT NULL    |            |       |
# | start_turn    | 開始局面           | integer(4)     |             |            | G     |
# | critical_turn | 開戦               | integer(4)     |             |            | H     |
# | outbreak_turn | Outbreak turn      | integer(4)     |             |            | I     |
# | image_turn    | OGP画像の局面      | integer(4)     |             |            |       |
# | created_at    | 作成日時           | datetime       | NOT NULL    |            |       |
# | updated_at    | 更新日時           | datetime       | NOT NULL    |            |       |
# |---------------+--------------------+----------------+-------------+------------+-------|
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

  describe "ファイルアップロードして変換" do
    let :uploaded_file do
      tempfile = Tempfile.open
      tempfile.write("68S")
      ActionDispatch::Http::UploadedFile.new(filename: "嬉野流.kif", type: "text/plain", tempfile: tempfile.open)
    end
    let :record do
      FreeBattle.create!(kifu_file: uploaded_file)
    end
    assert { record.kifu_body == "68S" }
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
        assert { value[:image]       == "http://0.0.0.0:3000/x/free_battle1.png?vpoint=black&turn=5" }
        assert { value[:description] == nil                                                          }
      end
    end

    it "param_as_to_png_options" do
      assert { record.param_as_to_png_options                     == {width: 1200, height: 630} }
      assert { record.param_as_to_png_options("width" => "")      == {width: 1200, height: 630} }
      assert { record.param_as_to_png_options("width" => "800")   == {width:  800, height: 630} }
      assert { record.param_as_to_png_options("height" => "9999") == {width: 1200, height: 630} }
      assert { record.param_as_to_png_options("other" => "12.34") == {width: 1200, height: 630, other: 12.34} }
      assert { record.param_as_to_png_options("other" => "true")  == {width: 1200, height: 630, other: true}  }
    end

    it "to_dynamic_png" do
      assert { record.to_dynamic_png.include?("PNG") }
    end

    # it "modal_on_index_path" do
    #   assert { record.modal_on_index_path == "/x?vpoint=black&modal_id=free_battle1&turn=5" }
    # end

    it "adjust_turn" do
      assert { record.adjust_turn(-1) == 5 }
      assert { record.adjust_turn( 6) == 5 }
      assert { record.adjust_turn(-9) == 0 }
    end

    it "turn" do
      assert { record.display_turn == 5 }
    end
  end

  describe "「**解析」などが含まれる巨大なKIFはいったん綺麗にする" do
    let :record do
      FreeBattle.create!(kifu_body: <<~EOT)
手数----指手---------消費時間--
**Engines 0 HoneyWaffle WCSC28
**解析
*一致率 先手 21% = 14/64  後手 40% = 26/64
*棋戦詳細：ライバル対決
   1 ５六歩(57)        ( 0:00/00:00:00)
**解析
**候補手
EOT
    end

    it do
      assert { record.kifu_body == <<~EOT }
手数----指手---------消費時間--
*一致率 先手 21% = 14/64  後手 40% = 26/64
*棋戦詳細：ライバル対決
   1 ５六歩(57)        ( 0:00/00:00:00)
EOT
    end
  end

  describe "ぴよ将棋？の日付フォーマット読み取り" do
    let :record do
      FreeBattle.create!(kifu_body: "開始日時：2020年02月07日(金) 20：36：15")
    end
    it do
      assert { record.battled_at.to_s == "2020-02-07 20:36:15 +0900" }
    end
  end

  describe "駒落ち判定" do
    let :record do
      FreeBattle.create!(kifu_body: "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
    end
    it do
      assert { record.preset_info.key == :"角落ち" }
    end
  end
end

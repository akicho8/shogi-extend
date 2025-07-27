# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+-------------------+-------------+---------------------+-------------------+-------|
# | name              | desc              | type        | opts                | refs              | index |
# |-------------------+-------------------+-------------+---------------------+-------------------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK         |                   |       |
# | key               | 対局ユニークキー  | string(255) | NOT NULL            |                   | A!    |
# | battled_at        | 対局日時          | datetime    | NOT NULL            |                   | B     |
# | csa_seq           | 棋譜              | text(65535) | NOT NULL            |                   |       |
# | win_user_id       | 勝者              | integer(8)  |                     | => Swars::User#id | C     |
# | turn_max          | 手数              | integer(4)  | NOT NULL            |                   | D     |
# | meta_info         | メタ情報          | text(65535) | NOT NULL            |                   |       |
# | accessed_at       | 最終アクセス日時  | datetime    | NOT NULL            |                   | E     |
# | sfen_body         | SFEN形式棋譜      | text(65535) | NOT NULL            |                   |       |
# | sfen_hash         | Sfen hash         | string(255) | NOT NULL            |                   |       |
# | start_turn        | 開始局面          | integer(4)  |                     |                   | F     |
# | critical_turn     | 開戦              | integer(4)  |                     |                   | G     |
# | outbreak_turn     | Outbreak turn     | integer(4)  |                     |                   | H     |
# | image_turn        | OGP画像の局面     | integer(4)  |                     |                   |       |
# | created_at        | 作成日時          | datetime    | NOT NULL            |                   |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL            |                   |       |
# | xmode_id          | Xmode             | integer(8)  | NOT NULL            |                   | I     |
# | preset_id         | Preset            | integer(8)  | NOT NULL            | => Preset#id      | J     |
# | rule_id           | Rule              | integer(8)  | NOT NULL            |                   | K     |
# | final_id          | Final             | integer(8)  | NOT NULL            |                   | L     |
# | analysis_version  | Analysis version  | integer(4)  | DEFAULT(0) NOT NULL |                   |       |
# | starting_position | Starting position | string(255) |                     |                   |       |
# | imode_id          | Imode             | integer(8)  | NOT NULL            |                   | M     |
# |-------------------+-------------------+-------------+---------------------+-------------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# 【警告:リレーション欠如】Swars::Userモデルで has_many :swars/battles されていません
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Swars::Battle, type: :model, swars_spec: true do
  let :record do
    Swars::Battle.create!(csa_seq: Swars::Battle::OLD_CSA_SEQ)
  end

  it "KIFの直リンクがモデルから取れる" do
    assert { record.kif_url == "http://localhost:3000/w/alice-bob-20000101_000000.kif" }
  end

  it "keyの重複はDBでのみチェックする" do
    Swars::Battle.create!(key: "x")
    expect { Swars::Battle.create!(key: "x") }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  describe "Twitterカード" do
    describe "to_twitter_card_params" do
      let :value do
        record.to_twitter_card_params
      end
      it "works" do
        assert { value[:title]       == "将棋ウォーズ(10分) user1 30級 vs user2 30級"              }
        assert { value[:url]         == nil                                                        }
        assert { value[:image]       == "http://localhost:3000/w/alice-bob-20000101_000000.png?turn=5&viewpoint=black" }
        assert { value[:description] == "嬉野流 新嬉野流 vs 三間飛車 2手目△3二飛戦法"                                   }
      end
      it "turnを変更できる" do
        assert { record.to_twitter_card_params(turn: 0)[:image].include?("turn=0") }
      end
    end

    it "title" do
      assert { record.title == "user1 30級 vs user2 30級" }
    end

    it "description" do
      assert { record.description == "嬉野流 新嬉野流 vs 三間飛車 2手目△3二飛戦法" }
    end
  end

  describe "時間チャート" do
    it "raw_sec_list_all: 消費時間" do
      assert { record.raw_sec_list_all == [1, 3, 5, 7, 2] }
    end

    it "raw_sec_list: それぞれの消費時間" do
      assert { record.raw_sec_list(:black) == [1, 5, 2] }
      assert { record.raw_sec_list(:white) == [3, 7]    }
    end

    it "time_chart_params: chart.jsに渡すデータがある" do
      assert { record.time_chart_params[:tcv_normal].has_key?(:datasets) }
      assert { record.time_chart_params[:tcv_accretion].has_key?(:datasets) }
    end

    describe "投了" do
      let :record do
        Swars::Battle.create!(final_key: :TORYO, csa_seq: Swars::Battle::OLD_CSA_SEQ)
      end

      it "後手は時間切れでないので放置時間は無し" do
        assert { record.memberships[1].leave_alone_seconds == nil }
      end
      it "それぞれの最大考慮時間が取れる" do
        assert { record.memberships[0].think_max == 5 }
        assert { record.memberships[1].think_max == 7 }
      end
      it "ラベルの最大" do
        assert { record.time_chart_label_max == 6 }
      end
      it "それぞれの時間チャートデータが取れる" do
        assert { record.time_chart_xy_list2(:black, false) == [{ x: 0, y: nil }, { x: 1, y: 1 }, { x: 2, y: nil }, { x: 3, y: 5 }, { x: 4, y: nil }, { x: 5, y: 2 }, { x: 6, y: nil }] }
        assert { record.time_chart_xy_list2(:white, false) == [{ x: 0, y: nil }, { x: 1, y: nil }, { x: 2, y: -3 }, { x: 3, y: nil }, { x: 4, y: -7 }, { x: 5, y: nil }] }
      end
      it "累計のデータが取れる" do
        assert { record.time_chart_xy_list2(:black, true) == [{ x: 0, y: nil }, { x: 1, y: 1 }, { x: 2, y: nil }, { x: 3, y: 6 }, { x: 4, y: nil }, { x: 5, y: 8 }, { x: 6, y: nil }] }
      end
    end

    describe "時間切れ" do
      let :record do
        Swars::Battle.create!(final_key: :TIMEOUT, csa_seq: Swars::Battle::OLD_CSA_SEQ)
      end

      it "後手の手番で時間切れなので残り秒数が取得できる" do
        assert { record.memberships[1].leave_alone_seconds == 590 }
      end
      it "後手の最大考慮時間は100ではなく500になっている" do
        assert { record.memberships[1].think_max == 590 }
      end
      it "後手のチャートの最後にそれを追加してある" do
        assert { record.time_chart_xy_list2(:black, false) == [{ x: 0, y: nil }, { x: 1, y: 1 }, { x: 2, y: nil }, { x: 3, y: 5 }, { x: 4, y: nil }, { x: 5, y: 2 }, { x: 6, y: nil }] }
        assert { record.time_chart_xy_list2(:white, false) == [{ x: 0, y: nil }, { x: 1, y: nil }, { x: 2, y: -3 }, { x: 3, y: nil }, { x: 4, y: -7 }, { x: 5, y: nil }, { x: 6, y: -590 }, { x: 7, y: nil }] }
      end
      it "そのためチャートのラベルは増えている" do
        assert { record.time_chart_label_max == 6 }
      end
    end

    describe "0手目で終了" do
      let :record do
        Swars::Battle.create!(csa_seq: [])
      end
      it "データがないときは0" do
        assert { record.memberships[0].think_max == 0 }
        assert { record.memberships[1].think_max == 0 }
      end
    end
  end

  describe "相入玉タグ" do
    let :record do
      Swars::Battle.create!(csa_seq: [["+5756FU", 0], ["-5354FU", 0], ["+5958OU", 0], ["-5152OU", 0], ["+5857OU", 0], ["-5253OU", 0], ["+5746OU", 0], ["-5364OU", 0], ["+4645OU", 0], ["-6465OU", 0], ["+4544OU", 0], ["-6566OU", 0], ["+4453OU", 0], ["-6657OU", 0]])
    end
    it "works" do
      assert { record.memberships[0].note_tag_list == ["相入玉"] }
      assert { record.memberships[1].note_tag_list == ["相入玉"] }
    end
  end

  it "垢BANした人の対局と垢BANされていない人の対局を分けるリレーションが正しい" do
    user1, user2 = record.users
    assert { Swars::Battle.ban_only.count == 0 }
    assert { Swars::Battle.ban_except.count == 1 }
    user1.ban!
    assert { Swars::Battle.ban_only.count == 1 }
    assert { Swars::Battle.ban_except.count == 0 }
  end

  it "最終対局日時をすばやく確認できるように create のタイミングで user.latest_battled_at を更新する" do
    user = nil
    Timecop.freeze("1999-01-01") { user = Swars::User.create! }
    battle = Swars::Battle.create! do |e|
      e.memberships.build(user: user)
    end
    user.reload
    assert { user.latest_battled_at.to_fs(:ymd) == "2000-01-01" }
  end

  it "rebuild すると必ず analysis_version を更新する" do
    battle = Swars::Battle.create!
    assert { battle.analysis_version == Bioshogi::ANALYSIS_VERSION }
    battle.update!(analysis_version: 0)
    battle = Swars::Battle.find(battle.id) # インスタンス変数を内部に持っているため reload ではだめ
    assert { battle.analysis_version == 0 }
    capture(:stdout) { battle.rebuild }
    assert { battle.analysis_version == Bioshogi::ANALYSIS_VERSION }
  end
end

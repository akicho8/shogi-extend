# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |---------------+------------------+--------------+-------------+------+-------|
# | name          | desc             | type         | opts        | refs | index |
# |---------------+------------------+--------------+-------------+------+-------|
# | id            | ID               | integer(8)   | NOT NULL PK |      |       |
# | key           | 対局ユニークキー | string(255)  | NOT NULL    |      | A!    |
# | battled_at    | 対局日時         | datetime     | NOT NULL    |      | F     |
# | rule_key      | ルール           | string(255)  | NOT NULL    |      | B     |
# | csa_seq       | 棋譜             | text(65535)  | NOT NULL    |      |       |
# | final_key     | 結末             | string(255)  | NOT NULL    |      | C     |
# | win_user_id   | 勝者             | integer(8)   |             |      | D     |
# | turn_max      | 手数             | integer(4)   | NOT NULL    |      | G     |
# | meta_info     | メタ情報         | text(65535)  | NOT NULL    |      |       |
# | accessed_at   | 最終アクセス日時 | datetime     | NOT NULL    |      |       |
# | outbreak_turn | Outbreak turn    | integer(4)   |             |      | E     |
# | created_at    | 作成日時         | datetime     | NOT NULL    |      |       |
# | updated_at    | 更新日時         | datetime     | NOT NULL    |      |       |
# | preset_key    | 手合割           | string(255)  | NOT NULL    |      |       |
# | start_turn    | 開始局面         | integer(4)   |             |      |       |
# | critical_turn | 開戦             | integer(4)   |             |      | H     |
# | saturn_key    | 公開範囲         | string(255)  | NOT NULL    |      | I     |
# | sfen_body     | SFEN形式棋譜     | string(8192) |             |      |       |
# | image_turn    | OGP画像の局面    | integer(4)   |             |      |       |
# | sfen_hash     | Sfen hash        | string(255)  |             |      |       |
# |---------------+------------------+--------------+-------------+------+-------|

require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    before do
      Swars.setup
    end

    let :record do
      Battle.create!
    end

    describe "アイコン" do
      describe "基本" do
        def test(*keys)
          Battle.create! do |e|
            keys.each do |key|
              e.memberships.build(user: User.create!(grade: Grade.find_by(key: key)))
            end
          end
        end
        it do
          test("初段", "二段").memberships[0].icon_html.include?("numeric-1-circle")
          test("初段", "二段").memberships[1].icon_html.include?("emoticon-dead-outline")
        end
      end
      describe "寝る" do
        def test(a)
          Battle.create!(csa_seq: [["+7968GI", 600], ["-8232HI", 600], ["+5756FU", 600 - a]])
        end
        it do
          test(119).memberships[0].icon_html.include?("star")
          test(120).memberships[0].icon_html == "😪"
          test(180).memberships[0].icon_html == "😴"
        end
      end
    end

    describe "Twitterカード" do
      describe "to_twitter_card_params" do
        let :value do
          record.to_twitter_card_params
        end
        it do
          assert { value[:title]       == "将棋ウォーズ(10分) user1 30級 vs user2 30級"                         }
          assert { value[:url]         == "http://localhost:3000/w?description=&flip=false&modal_id=battle1&title=&turn=5" }
          assert { value[:image]       == "http://localhost:3000/w/battle1.png?flip=false&turn=5"                          }
          assert { value[:description] == "嬉野流 居飛車 居玉 vs △３ニ飛戦法 振り飛車 居玉"                    }
        end
        it "turnを変更できる" do
          assert { record.to_twitter_card_params(turn: 0)[:url].include?("turn=0") }
        end
      end

      it "title" do
        assert { record.title == "user1 30級 vs user2 30級" }
      end

      it "description" do
        assert { record.description == "嬉野流 居飛車 居玉 vs △３ニ飛戦法 振り飛車 居玉" }
      end
    end

    describe "時間チャート" do
      it "raw_sec_list: それぞれの消費時間" do
        assert { record.raw_sec_list(:black) == [1, 5, 2] }
        assert { record.raw_sec_list(:white) == [3, 7]    }
      end

      it "time_chart_params: chart.jsに渡すデータ" do
        assert { record.time_chart_params.has_key?(:datasets) }
      end

      describe "投了" do
        let :record do
          Swars::Battle.create!(final_key: :TORYO)
        end

        it "後手は時間切れでないので放置時間は無し" do
          assert { record.memberships[1].leave_alone_seconds == nil }
        end
        it "それぞれの最大考慮時間が取れる" do
          assert { record.memberships[0].think_max == 5 }
          assert { record.memberships[1].think_max == 7 }
        end
        it "それぞれの時間チャートデータが取れる" do
          assert { record.memberships[0].time_chart_xy_list == [{x: 1, y: 1 }, {x: 3, y:  5}, {x: 5, y: 2}] }
          assert { record.memberships[1].time_chart_xy_list == [{x: 2, y: -3}, {x: 4, y: -7},             ] }
        end
        it "なのでラベルは3つのみ" do
          assert { record.time_chart_label_max == 5 }
        end
      end

      describe "時間切れ" do
        let :record do
          Swars::Battle.create!(final_key: :TIMEOUT)
        end

        it "後手の手番で時間切れなので残り秒数が取得できる" do
          assert { record.memberships[1].leave_alone_seconds == 590 }
        end
        it "後手の最大考慮時間は100ではなく500になっている" do
          assert { record.memberships[1].think_max == 590 }
        end
        it "後手のチャートの最後にそれを追加してある" do
          assert { record.memberships[1].time_chart_xy_list == [{x: 2, y: -3}, {x: 4, y: -7}, {x: 6, y: -590} ] }
        end
        it "そのためチャートのラベルは4つに増えている" do
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
        Battle.create!(csa_seq: [["+5756FU", 0], ["-5354FU", 0], ["+5958OU", 0], ["-5152OU", 0], ["+5857OU", 0], ["-5253OU", 0], ["+5746OU", 0], ["-5364OU", 0], ["+4645OU", 0], ["-6465OU", 0], ["+4544OU", 0], ["-6566OU", 0], ["+4453OU", 0], ["-6657OU", 0]])
      end
      it do
        assert { record.note_tag_list                == ["入玉", "相入玉", "居飛車", "相居飛車"] }
        assert { record.memberships[0].note_tag_list == ["入玉", "相入玉", "居飛車", "相居飛車"] }
        assert { record.memberships[1].note_tag_list == ["入玉", "相入玉", "居飛車", "相居飛車"] }
      end
    end
  end
end

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |---------------+------------------+-------------+-------------+-------------------+-------|
# | name          | desc             | type        | opts        | refs              | index |
# |---------------+------------------+-------------+-------------+-------------------+-------|
# | id            | ID               | integer(8)  | NOT NULL PK |                   |       |
# | key           | 対局ユニークキー | string(255) | NOT NULL    |                   | A!    |
# | battled_at    | 対局日時         | datetime    | NOT NULL    |                   | B     |
# | rule_key      | ルール           | string(255) | NOT NULL    |                   | C     |
# | csa_seq       | 棋譜             | text(65535) | NOT NULL    |                   |       |
# | final_key     | 結末             | string(255) | NOT NULL    |                   | D     |
# | win_user_id   | 勝者             | integer(8)  |             | => Swars::User#id | E     |
# | turn_max      | 手数             | integer(4)  | NOT NULL    |                   | F     |
# | meta_info     | メタ情報         | text(65535) | NOT NULL    |                   |       |
# | accessed_at   | 最終アクセス日時 | datetime    | NOT NULL    |                   | G     |
# | preset_key    | 手合割           | string(255) | NOT NULL    |                   | H     |
# | sfen_body     | SFEN形式棋譜     | text(65535) | NOT NULL    |                   |       |
# | sfen_hash     | Sfen hash        | string(255) | NOT NULL    |                   |       |
# | start_turn    | 開始局面         | integer(4)  |             |                   | I     |
# | critical_turn | 開戦             | integer(4)  |             |                   | J     |
# | outbreak_turn | Outbreak turn    | integer(4)  |             |                   | K     |
# | image_turn    | OGP画像の局面    | integer(4)  |             |                   |       |
# | created_at    | 作成日時         | datetime    | NOT NULL    |                   |       |
# | updated_at    | 更新日時         | datetime    | NOT NULL    |                   |       |
# |---------------+------------------+-------------+-------------+-------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# 【警告:リレーション欠如】Swars::Userモデルで has_many :swars/battles されていません
#--------------------------------------------------------------------------------

require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    let :record do
      Battle.create!
    end

    describe "Twitterカード" do
      describe "to_twitter_card_params" do
        let :value do
          record.to_twitter_card_params
        end
        it do
          assert { value[:title]       == "将棋ウォーズ(10分) user1 30級 vs user2 30級"              }
          assert { value[:url]         == nil                                                        }
          assert { value[:image]       == "http://localhost:3000/w/battle1.png?turn=5&viewpoint=black" }
          assert { value[:description] == "新嬉野流 vs 2手目△３ニ飛戦法"                                   }
        end
        it "turnを変更できる" do
          assert { record.to_twitter_card_params(turn: 0)[:image].include?("turn=0") }
        end
      end

      it "title" do
        assert { record.title == "user1 30級 vs user2 30級" }
      end

      it "description" do
        assert { record.description == "新嬉野流 vs 2手目△３ニ飛戦法" }
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
        it "ラベルの最大" do
          assert { record.time_chart_label_max == 6 }
        end
        it "それぞれの時間チャートデータが取れる" do
          assert { record.time_chart_xy_list(:black) == [{x: 0, y: nil}, {x: 1, y: 1}, {x: 2, y: nil}, {x: 3, y: 5}, {x: 4, y: nil}, {x: 5, y: 2}, {x: 6, y: nil}] }
          assert { record.time_chart_xy_list(:white) == [{x: 0, y: nil}, {x: 1, y: nil}, {x: 2, y: -3}, {x: 3, y: nil}, {x: 4, y: -7}, {x: 5, y: nil}] }
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
          assert { record.time_chart_xy_list(:black) == [{x: 0, y: nil}, {x: 1, y: 1}, {x: 2, y: nil}, {x: 3, y: 5}, {x: 4, y: nil}, {x: 5, y: 2}, {x: 6, y: nil}] }
          assert { record.time_chart_xy_list(:white) == [{x: 0, y: nil}, {x: 1, y: nil}, {x: 2, y: -3}, {x: 3, y: nil}, {x: 4, y: -7}, {x: 5, y: nil}, {x: 6, y: -590}, {x: 7, y: nil}] }
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
        Battle.create!(csa_seq: [["+5756FU", 0], ["-5354FU", 0], ["+5958OU", 0], ["-5152OU", 0], ["+5857OU", 0], ["-5253OU", 0], ["+5746OU", 0], ["-5364OU", 0], ["+4645OU", 0], ["-6465OU", 0], ["+4544OU", 0], ["-6566OU", 0], ["+4453OU", 0], ["-6657OU", 0]])
      end
      it do
        assert { record.memberships[0].note_tag_list == ["入玉", "相入玉", "居飛車"] }
        assert { record.memberships[1].note_tag_list == ["入玉", "相入玉", "居飛車"] }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .............F...
# >> 
# >> Failures:
# >> 
# >>   1) Swars::Battle 時間チャート 時間切れ 後手のチャートの最後にそれを追加してある
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:119:in `block (4 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (2 levels) in <main>'
# >> 
# >> Finished in 5.67 seconds (files took 2.49 seconds to load)
# >> 17 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:113 # Swars::Battle 時間チャート 時間切れ 後手のチャートの最後にそれを追加してある
# >> 

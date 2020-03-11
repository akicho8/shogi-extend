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
# |---------------+------------------+--------------+-------------+------+-------|

require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    before do
      Swars.setup
    end

    before do
      user1 = User.create!
      user2 = User.create!

      @record = Battle.new
      @record.csa_seq = [["-7162GI", 599],  ["+2726FU", 597],  ["-4132KI", 594],  ["+6978KI", 590]]
      @record.memberships.build(user: user1, judge_key: :win,  location_key: :black)
      @record.memberships.build(user: user2, judge_key: :lose, location_key: :white)
      @record.save!
    end

    it "相入玉タグ" do
      user1 = User.create!
      user2 = User.create!

      battle = Battle.new
      battle.csa_seq = [["+5756FU", 0],["-5354FU", 0],["+5958OU", 0],["-5152OU", 0],["+5857OU", 0],["-5253OU", 0],["+5746OU", 0],["-5364OU", 0],["+4645OU", 0],["-6465OU", 0],["+4544OU", 0],["-6566OU", 0],["+4453OU", 0],["-6657OU", 0]]
      battle.memberships.build(user: user1, judge_key: :win,  location_key: :black)
      battle.memberships.build(user: user2, judge_key: :lose, location_key: :white)
      battle.save!                  # => true

      # puts battle.to_cached_kifu(:kif)
      assert { battle.note_tag_list                == ["入玉", "相入玉", "居飛車", "相居飛車"] }
      assert { battle.memberships[0].note_tag_list == ["入玉", "相入玉", "居飛車", "相居飛車"] }
      assert { battle.memberships[1].note_tag_list == ["入玉", "相入玉", "居飛車", "相居飛車"] }
    end

    it "sec_list" do
      assert { @record.sec_list(Bioshogi::Location[:black]) == [1, 5] }
      assert { @record.sec_list(Bioshogi::Location[:white]) == [3, 7] }
    end

    it "time_chart_params" do
      assert { @record.time_chart_params.has_key?(:datasets) }
    end
  end
end

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle2_records as Battle2Record)
#
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味             | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | id                 | ID               | integer(8)  | NOT NULL PK |                  |       |
# | battle_key         | Battle2 key       | string(255) | NOT NULL    |                  | A!    |
# | battled_at         | Battle2d at       | datetime    | NOT NULL    |                  |       |
# | battle2_rule_key    | Battle2 rule key  | string(255) | NOT NULL    |                  | B     |
# | csa_seq            | Csa seq          | text(65535) | NOT NULL    |                  |       |
# | battle2_state_key   | Battle2 state key | string(255) | NOT NULL    |                  | C     |
# | win_battle2_user_id | Win battle user  | integer(8)  |             | => Battle2User#id | D     |
# | turn_max           | 手数             | integer(4)  | NOT NULL    |                  |       |
# | kifu_header        | 棋譜ヘッダー     | text(65535) | NOT NULL    |                  |       |
# | mountain_url       | 将棋山脈URL      | string(255) |             |                  |       |
# | created_at         | 作成日時         | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時         | datetime    | NOT NULL    |                  |       |
# |--------------------+------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】Battle2Userモデルで has_many :battle2_records されていません
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe ResourceNs1::Battle2RecordsController, type: :controller do
  before do
    battle2_record_setup
    @battle2_record = Battle2Record.first
  end

  it "show" do
    get :show, params: {id: @battle2_record.to_param}
  end
end

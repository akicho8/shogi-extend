# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle2_records as Battle2Record)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | カラム名          | 意味              | タイプ      | 属性        | 参照 | INDEX |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | battle_key        | Battle key        | string(255) | NOT NULL    |      | A!    |
# | battled_at        | Battled at        | datetime    |             |      |       |
# | kifu_body         | 棋譜内容          | text(65535) | NOT NULL    |      |       |
# | battle2_state_key | Battle2 state key | string(255) | NOT NULL    |      | B     |
# | turn_max          | 手数              | integer(4)  | NOT NULL    |      |       |
# | meta_info         | 棋譜ヘッダー      | text(65535) | NOT NULL    |      |       |
# | mountain_url      | 将棋山脈URL       | string(255) |             |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      |       |
# |-------------------+-------------------+-------------+-------------+------+-------|

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

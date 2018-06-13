# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as Swars::BattleRecord)
#
# |---------------------------------------+---------------------------------------+-------------+-------------+-----------------------+-------|
# | カラム名                              | 意味                                  | タイプ      | 属性        | 参照                  | INDEX |
# |---------------------------------------+---------------------------------------+-------------+-------------+-----------------------+-------|
# | id                                    | ID                                    | integer(8)  | NOT NULL PK |                       |       |
# | battle_key                            | Battle key                            | string(255) | NOT NULL    |                       | A!    |
# | battled_at                            | Battled at                            | datetime    | NOT NULL    |                       |       |
# | battle_rule_key                       | Battle rule key                       | string(255) | NOT NULL    |                       | B     |
# | csa_seq                               | Csa seq                               | text(65535) | NOT NULL    |                       |       |
# | battle_state_key                      | Battle state key                      | string(255) | NOT NULL    |                       | C     |
# | win_battle_user_id              | Win swars battle user                 | integer(8)  |             | => Swars::BattleUser#id | D     |
# | turn_max                              | 手数                                  | integer(4)  | NOT NULL    |                       |       |
# | meta_info                             | 棋譜ヘッダー                          | text(65535) | NOT NULL    |                       |       |
# | mountain_url                          | 将棋山脈URL                           | string(255) |             |                       |       |
# | last_accessd_at                       | Last accessd at                       | datetime    | NOT NULL    |                       |       |
# | battle_access_logs_count | Swars battle record access logs count | integer(4)  | DEFAULT(0)  |                       |       |
# | created_at                            | 作成日時                              | datetime    | NOT NULL    |                       |       |
# | updated_at                            | 更新日時                              | datetime    | NOT NULL    |                       |       |
# |---------------------------------------+---------------------------------------+-------------+-------------+-----------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】Swars::BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe ResourceNs1::Swars::BattleRecordsController, type: :controller do
  before do
    swars_battle_record_setup
    @battle_record = Swars::BattleRecord.first
  end

  it "index" do
    get :index
    expect(response).to have_http_status(:ok)

    get :index, params: {query: "hanairobiyori"}
    expect(response).to have_http_status(:ok)
  end

  it "show" do
    get :show, params: {id: @battle_record.to_param}
    expect(response).to have_http_status(:ok)
  end
end

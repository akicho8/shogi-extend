# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+------------------+-------------+-------------+------+-------|
# | name              | desc             | type        | opts        | refs | index |
# |-------------------+------------------+-------------+-------------+------+-------|
# | id                | ID               | integer(8)  | NOT NULL PK |      |       |
# | key               | 対局ユニークキー | string(255) | NOT NULL    |      | A! B! |
# | battled_at        | 対局日時         | datetime    | NOT NULL    |      | B! F  |
# | rule_key          | ルール           | string(255) | NOT NULL    |      | C     |
# | csa_seq           | 棋譜             | text(65535) | NOT NULL    |      |       |
# | final_key         | 結末             | string(255) | NOT NULL    |      | D     |
# | win_user_id       | 勝者             | integer(8)  |             |      | E     |
# | turn_max          | 手数             | integer(4)  | NOT NULL    |      | G     |
# | meta_info         | メタ情報         | text(65535) | NOT NULL    |      |       |
# | last_accessd_at   | 最終アクセス日時 | datetime    | NOT NULL    |      |       |
# | access_logs_count | アクセス数       | integer(4)  | DEFAULT(0)  |      |       |
# | created_at        | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時         | datetime    | NOT NULL    |      |       |
# | preset_key        | 手合割           | string(255) | NOT NULL    |      |       |
# |-------------------+------------------+-------------+-------------+------+-------|

require 'rails_helper'

RSpec.describe Swars::BattlesController, type: :controller do
  before do
    swars_battle_setup
    @battle = Swars::Battle.first
  end

  it "index" do
    get :index
    expect(response).to have_http_status(:ok)

    get :index, params: {query: "devuser1"}
    expect(response).to have_http_status(:ok)
  end

  it "show" do
    get :show, params: {id: @battle.to_param}
    expect(response).to have_http_status(:ok)
  end
end

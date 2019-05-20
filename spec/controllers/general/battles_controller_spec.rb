# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (general_battles as General::Battle)
#
# |-----------------+-----------------+--------------+-------------+------+-------|
# | name            | desc            | type         | opts        | refs | index |
# |-----------------+-----------------+--------------+-------------+------+-------|
# | id              | ID              | integer(8)   | NOT NULL PK |      |       |
# | key             | 対局キー        | string(255)  | NOT NULL    |      | A!    |
# | battled_at      | 対局日          | datetime     |             |      | C     |
# | kifu_body       | 棋譜内容        | text(65535)  | NOT NULL    |      |       |
# | final_key       | 結果            | string(255)  | NOT NULL    |      | B     |
# | turn_max        | 手数            | integer(4)   | NOT NULL    |      | D     |
# | meta_info       | 棋譜ヘッダー    | text(65535)  | NOT NULL    |      |       |
# | last_accessd_at | Last accessd at | datetime     | NOT NULL    |      |       |
# | created_at      | 作成日時        | datetime     | NOT NULL    |      |       |
# | updated_at      | 更新日時        | datetime     | NOT NULL    |      |       |
# | start_turn      | 開始手数        | integer(4)   |             |      |       |
# | critical_turn   | 開戦            | integer(4)   |             |      |       |
# | saturn_key      | Saturn key      | string(255)  | NOT NULL    |      |       |
# | sfen_body       | Sfen body       | string(8192) |             |      |       |
# |-----------------+-----------------+--------------+-------------+------+-------|

require 'rails_helper'

RSpec.describe General::BattlesController, type: :controller do
  before do
    general_battle_setup
    @battle = General::Battle.first
  end

  it "index" do
    get :index
    assert { controller.current_records }
    expect(response).to have_http_status(:ok)
  end

  it "show" do
    get :show, params: {id: @battle.to_param}
    expect(response).to have_http_status(:ok)
  end
end

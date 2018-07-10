# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (swars_battles as Swars::Battle)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | name              | desc              | type        | opts        | refs | index |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | key               | Key               | string(255) | NOT NULL    |      | A!    |
# | battled_at        | Battled at        | datetime    | NOT NULL    |      |       |
# | rule_key          | Rule key          | string(255) | NOT NULL    |      | B     |
# | csa_seq           | Csa seq           | text(65535) | NOT NULL    |      |       |
# | battle_state_key  | Battle state key  | string(255) | NOT NULL    |      | C     |
# | win_user_id       | Win user          | integer(8)  |             |      | D     |
# | turn_max          | Turn max          | integer(4)  | NOT NULL    |      |       |
# | meta_info         | Meta info         | text(65535) | NOT NULL    |      |       |
# | last_accessd_at   | Last accessd at   | datetime    | NOT NULL    |      |       |
# | access_logs_count | Access logs count | integer(4)  | DEFAULT(0)  |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      |       |
# |-------------------+-------------------+-------------+-------------+------+-------|

require 'rails_helper'

RSpec.describe Swars::BattlesController, type: :controller do
  before do
    swars_battle_setup
    @battle = Swars::Battle.first
  end

  it "index" do
    get :index
    expect(response).to have_http_status(:ok)

    get :index, params: {query: "hanairobiyori"}
    expect(response).to have_http_status(:ok)
  end

  it "show" do
    get :show, params: {id: @battle.to_param}
    expect(response).to have_http_status(:ok)
  end
end

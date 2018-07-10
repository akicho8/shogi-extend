# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (general_battles as General::Battle)
#
# |------------------+------------------+-------------+-------------+------+-------|
# | name             | desc             | type        | opts        | refs | index |
# |------------------+------------------+-------------+-------------+------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |      |       |
# | key              | Key              | string(255) | NOT NULL    |      | A!    |
# | battled_at       | Battled at       | datetime    |             |      |       |
# | kifu_body        | Kifu body        | text(65535) | NOT NULL    |      |       |
# | battle_state_key | Battle state key | string(255) | NOT NULL    |      | B     |
# | turn_max         | Turn max         | integer(4)  | NOT NULL    |      |       |
# | meta_info        | Meta info        | text(65535) | NOT NULL    |      |       |
# | last_accessd_at  | Last accessd at  | datetime    | NOT NULL    |      |       |
# | created_at       | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |      |       |
# |------------------+------------------+-------------+-------------+------+-------|

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

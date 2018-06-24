# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battleテーブル (general_battles as General::Battle)
#
# |------------------+------------------+-------------+-------------+------+-------|
# | カラム名         | 意味             | タイプ      | 属性        | 参照 | INDEX |
# |------------------+------------------+-------------+-------------+------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |      |       |
# | battle_key       | Battle key       | string(255) | NOT NULL    |      | A!    |
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

  it "show" do
    get :show, params: {id: @battle.to_param}
  end
end

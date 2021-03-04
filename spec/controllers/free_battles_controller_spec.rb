# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+--------------------+-------------+-------------+------------+-------|
# | name          | desc               | type        | opts        | refs       | index |
# |---------------+--------------------+-------------+-------------+------------+-------|
# | id            | ID                 | integer(8)  | NOT NULL PK |            |       |
# | key           | ユニークなハッシュ | string(255) | NOT NULL    |            | A!    |
# | title         | タイトル           | string(255) |             |            |       |
# | kifu_body     | 棋譜               | text(65535) | NOT NULL    |            |       |
# | sfen_body     | SFEN形式棋譜       | text(65535) | NOT NULL    |            |       |
# | turn_max      | 手数               | integer(4)  | NOT NULL    |            | B     |
# | meta_info     | 棋譜ヘッダー       | text(65535) | NOT NULL    |            |       |
# | battled_at    | Battled at         | datetime    | NOT NULL    |            | C     |
# | use_key       | Use key            | string(255) | NOT NULL    |            | D     |
# | accessed_at   | Accessed at        | datetime    | NOT NULL    |            | E     |
# | user_id       | User               | integer(8)  |             | => User#id | F     |
# | preset_key    | Preset key         | string(255) | NOT NULL    |            | G     |
# | description   | 説明               | text(65535) | NOT NULL    |            |       |
# | sfen_hash     | Sfen hash          | string(255) | NOT NULL    |            |       |
# | start_turn    | 開始局面           | integer(4)  |             |            | H     |
# | critical_turn | 開戦               | integer(4)  |             |            | I     |
# | outbreak_turn | Outbreak turn      | integer(4)  |             |            | J     |
# | image_turn    | OGP画像の局面      | integer(4)  |             |            |       |
# | created_at    | 作成日時           | datetime    | NOT NULL    |            |       |
# | updated_at    | 更新日時           | datetime    | NOT NULL    |            |       |
# |---------------+--------------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe FreeBattlesController, type: :controller do
  # before(:context) do
  #   Actb.setup
  # end
  #
  # before do
  #   user_login(key: "sysop")
  #
  #   @free_battle = FreeBattle.create!
  # end
  #
  # it "index" do
  #   get :index
  #   assert { response.status == 200 }
  # end
  #
  # it "index + modal_id" do
  #   get :index, params: { modal_id: @free_battle.to_param }
  #   assert { response.status == 200 }
  # end
  #
  # it "show html" do
  #   get :show, params: {id: @free_battle.to_param}
  #   assert { response.status == 200 }
  # end
  #
  # it "show png" do
  #   get :show, params: {id: @free_battle.to_param, format: "png"}
  #   assert { response.status == 200 }
  # end
  #
  # it "show png turn" do
  #   get :show, params: {id: @free_battle.to_param, format: "png", turn: -1}
  #   assert { response.status == 200 }
  # end
  #
  # it "棋譜印刷" do
  #   get :show, params: {id: @free_battle.to_param, formal_sheet: true}
  #   assert { response.status == 200 }
  # end
  #
  # it "new" do
  #   get :new
  #   assert { response.status == 200 }
  # end
  #
  # it "コピペ新規" do
  #   get :new, params: {source_id: @free_battle.to_param}
  #   assert { response.status == 302 }
  # end
  #
  # it "create" do
  #   post :create, params: {}
  #   assert { response.status == 302 }
  # end
  #
  # it "edit" do
  #   get :edit, params: {id: @free_battle.to_param}
  #   assert { response.status == 200 }
  # end
  #
  # it "update" do
  #   put :update, params: {id: @free_battle.to_param}
  #   assert { response.status == 302 }
  # end
  #
  # it "destroy" do
  #   delete :destroy, params: {id: @free_battle.to_param}
  #   assert { FreeBattle.where(id: @free_battle.to_param).none? }
  #   assert { response.status == 302 }
  # end
end

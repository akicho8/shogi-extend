# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+---------------+----------------+-------------+--------------+-------|
# | name          | desc          | type           | opts        | refs         | index |
# |---------------+---------------+----------------+-------------+--------------+-------|
# | id            | ID            | integer(8)     | NOT NULL PK |              |       |
# | key           | キー          | string(255)    | NOT NULL    |              | A!    |
# | kifu_body     | 棋譜          | text(65535)    |             |              |       |
# | turn_max      | 手数          | integer(4)     | NOT NULL    |              | C     |
# | meta_info     | 棋譜ヘッダー  | text(16777215) | NOT NULL    |              |       |
# | battled_at    | Battled at    | datetime       | NOT NULL    |              | B     |
# | created_at    | 作成日時      | datetime       | NOT NULL    |              |       |
# | updated_at    | 更新日時      | datetime       | NOT NULL    |              |       |
# | user_id       | User          | integer(8)     |             | => User#id   | H     |
# | title         | タイトル      | string(255)    |             |              |       |
# | description   | 説明          | text(65535)    | NOT NULL    |              |       |
# | start_turn    | 開始局面      | integer(4)     |             |              |       |
# | critical_turn | 開戦          | integer(4)     |             |              | D     |
# | saturn_key    | Saturn key    | string(255)    | NOT NULL    |              | E     |
# | sfen_body     | SFEN形式棋譜  | text(65535)    | NOT NULL    |              |       |
# | image_turn    | OGP画像の局面 | integer(4)     |             |              |       |
# | use_key       | Use key       | string(255)    | NOT NULL    |              | G     |
# | outbreak_turn | Outbreak turn | integer(4)     |             |              | F     |
# | accessed_at   | 参照日時      | datetime       | NOT NULL    |              | I     |
# | sfen_hash     | Sfen hash     | string(255)    | NOT NULL    |              |       |
# | preset_id     | Preset        | integer(8)     |             | => Preset#id | J     |
# |---------------+---------------+----------------+-------------+--------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# User.has_one :profile
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe FreeBattlesController, type: :controller do
  before do
    @free_battle = FreeBattle.create!
  end

  # it "index" do
  #   get :index
  #   assert { response.status == 200 }
  # end
  #
  # it "index + modal_id" do
  #   get :index, params: { modal_id: @free_battle.to_param }
  #   assert { response.status == 200 }
  # end

  it "kif" do
    get :show, params: { id: @free_battle.to_param, format: "kif" }
    assert { response.status == 200 }
  end

  it "ki2" do
    get :show, params: { id: @free_battle.to_param, format: "ki2" }
    assert { response.status == 200 }
  end

  it "sfen" do
    get :show, params: { id: @free_battle.to_param, format: "sfen" }
    assert { response.status == 200 }
  end

  it "csa" do
    get :show, params: { id: @free_battle.to_param, format: "csa" }
    assert { response.status == 200 }
  end

  it "png" do
    get :show, params: { id: @free_battle.to_param, format: "png" }
    assert { response.status == 302 }
  end

  it "KIF表示したときに棋譜の上部にリンクを含んでいない" do
    get :show, params: { id: @free_battle.to_param, format: "kif" }
    assert { !response.body.match?(/詳細URL|ぴよ将棋|KENTO/) }
  end

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

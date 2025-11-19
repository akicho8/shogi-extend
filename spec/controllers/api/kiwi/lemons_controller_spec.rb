# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 動画 (kiwi_lemons as Kiwi::Lemon)
#
# |------------------+--------------------------+-------------+-------------+------+-------|
# | name             | desc                     | type        | opts        | refs | index |
# |------------------+--------------------------+-------------+-------------+------+-------|
# | id               | ID                       | integer(8)  | NOT NULL PK |      |       |
# | user_id          | 所有者                   | integer(8)  | NOT NULL    |      | A     |
# | recordable_type  | 棋譜情報(クラス名)       | string(255) | NOT NULL    |      | B     |
# | recordable_id    | 棋譜情報                 | integer(8)  | NOT NULL    |      | B     |
# | all_params       | 変換用全パラメータ       | text(65535) | NOT NULL    |      |       |
# | process_begin_at | 開始日時                 | datetime    |             |      | C     |
# | process_end_at   | 終了日時(失敗時も入る)   | datetime    |             |      | D     |
# | successed_at     | 正常終了日時             | datetime    |             |      | E     |
# | errored_at       | 失敗終了日時             | datetime    |             |      | F     |
# | error_message    | エラー文言               | text(65535) |             |      |       |
# | content_type     | 動画タイプ               | string(255) |             |      |       |
# | file_size        | 動画サイズ               | integer(4)  |             |      |       |
# | ffprobe_info     | ffprobeの内容            | text(65535) |             |      |       |
# | browser_path     | 動画WEBパス              | string(255) |             |      |       |
# | filename_human   | 動画の人間向けファイル名 | string(255) |             |      |       |
# | created_at       | 作成日時                 | datetime    | NOT NULL    |      | G     |
# | updated_at       | 更新日時                 | datetime    | NOT NULL    |      |       |
# |------------------+--------------------------+-------------+-------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Kiwi::Lemon モデルに belongs_to :recordable, polymorphic: true を追加しよう
# [Warning: Need to add relation] Kiwi::Lemon モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Api::Kiwi::LemonsController, type: :controller, kiwi: true do
  include KiwiSupport

  before do
    @user1 = user_login(User.admin)
  end

  it "xresource_fetch" do
    post :xresource_fetch, params: {}.as_json, as: :json
    assert { response.status == 200 }
  end

  it "record_create" do
    post :record_create, params: mp4_params1.as_json, as: :json
    assert { response.status == 200 }
  end

  it "zombie_kill" do
    post :zombie_kill, params: {}.as_json, as: :json
    assert { response.status == 200 }
  end

  it "retry_run" do
    post :retry_run, params: { id: lemon1.id }.as_json, as: :json
    assert { response.status == 200 }
  end

  it "destroy_run" do
    post :destroy_run, params: { id: lemon1.id }.as_json, as: :json
    assert { response.status == 200 }
  end

  it "all_info_reload" do
    post :all_info_reload, params: {}.as_json, as: :json
    assert { response.status == 200 }
  end

  it "zombie_kill_now" do
    post :zombie_kill_now, params: {}.as_json, as: :json
    assert { response.status == 200 }
  end

  it "background_job_kick" do
    post :background_job_kick, params: {}.as_json, as: :json
    assert { response.status == 200 }
  end
end

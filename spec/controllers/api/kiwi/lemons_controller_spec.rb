# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 動画 (kiwi_lemons as Kiwi::Lemon)
#
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | name             | desc             | type        | opts        | refs                       | index |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |                            |       |
# | user_id          | User             | integer(8)  | NOT NULL    | => User#id                 | A     |
# | recordable_type  | Recordable type  | string(255) | NOT NULL    | SpecificModel(polymorphic) | B     |
# | recordable_id    | Recordable       | integer(8)  | NOT NULL    | => (recordable_type)#id    | B     |
# | all_params       | All params       | text(65535) | NOT NULL    |                            |       |
# | process_begin_at | Process begin at | datetime    |             |                            | C     |
# | process_end_at   | Process end at   | datetime    |             |                            | D     |
# | successed_at     | Successed at     | datetime    |             |                            | E     |
# | errored_at       | Errored at       | datetime    |             |                            | F     |
# | error_message    | Error message    | text(65535) |             |                            |       |
# | content_type     | Content type     | string(255) |             |                            |       |
# | file_size        | File size        | integer(4)  |             |                            |       |
# | ffprobe_info     | Ffprobe info     | text(65535) |             |                            |       |
# | browser_path     | Browser path     | string(255) |             |                            |       |
# | filename_human   | Filename human   | string(255) |             |                            |       |
# | created_at       | 作成日時         | datetime    | NOT NULL    |                            | G     |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |                            |       |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Api::Kiwi::LemonsController, type: :controller do
  include KiwiSupport

  before do
    @user1 = user_login
  end

  it "latest_info_reload" do
    post :latest_info_reload, params: {}.as_json, as: :json
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
end

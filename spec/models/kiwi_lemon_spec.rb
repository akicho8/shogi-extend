# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Kiwi record (lemons as Kiwi::Lemon)
#
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | name             | desc             | type        | opts        | refs                       | index |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |                            |       |
# | user_id          | User             | integer(8)  | NOT NULL    | => User#id                 | A     |
# | recordable_type  | Recordable type  | string(255) | NOT NULL    | SpecificModel(polymorphic) | B     |
# | recordable_id    | Recordable       | integer(8)  | NOT NULL    | => (recordable_type)#id    | B     |
# | all_params   | Convert params   | text(65535) | NOT NULL    |                            |       |
# | process_begin_at | Process begin at | datetime    |             |                            | C     |
# | process_end_at   | Process end at   | datetime    |             |                            | D     |
# | successed_at     | Successed at     | datetime    |             |                            | E     |
# | errored_at       | Errored at       | datetime    |             |                            | F     |
# | error_message    | Error message    | text(65535) |             |                            |       |
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

require 'rails_helper'

RSpec.describe Kiwi::Lemon, type: :model do
  include KiwiSupport

  def entry_only
    free_battle = user1.free_battles.create!(kifu_body: params1[:body], use_key: "kiwi_lemon")
    user1.kiwi_lemons.create!(recordable: free_battle, all_params: params1[:all_params])
  end

  it "works" do
    record = entry_only
    record.main_process!
    record.reload
    assert { record.status_key == "成功" }
    assert { record.browser_path.match?(%{/system/x-files/.*mp4}) }
  end

  it "background_job_kick" do
    entry_only
    Kiwi::Lemon.background_job_kick
  end

  it "process_in_sidekiq" do
    entry_only
    Kiwi::Lemon.process_in_sidekiq
  end

  it "zombie_kill" do
    Kiwi::Lemon.zombie_kill
  end

  it "info" do
    entry_only
    assert { Kiwi::Lemon.info }
  end

  it "everyone_broadcast" do
    entry_only
    Kiwi::Lemon.everyone_broadcast
  end
end

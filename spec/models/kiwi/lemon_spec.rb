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

module Kiwi
  RSpec.describe Lemon, type: :model do
    include KiwiSupport

    it "動画生成" do
      lemon1.main_process
      lemon1.reload

      assert { lemon1.status_key == "成功" }

      assert { lemon1.real_path.to_s.match?(/public/) }
      assert { lemon1.browser_path.match?(/system.*mp4/) }

      assert { lemon1.thumbnail_real_path.to_s.match?(/public.*thumbnail/) }
      assert { lemon1.thumbnail_browser_path.match?(/system.*thumbnail/) }
      assert { lemon1.thumbnail_real_path.exist? == false }
    end

    it "ワーカーが動いてなかったら動かす" do
      lemon1
      Lemon.background_job_kick
    end

    it "ワーカー関係なく全処理実行" do
      lemon1
      Lemon.process_in_sidekiq
    end

    it "ゾンビを成仏させる" do
      Lemon.zombie_kill
    end

    it "info" do
      lemon1
      assert { Lemon.info }
    end

    it "「みんな」の反映" do
      lemon1
      Lemon.everyone_broadcast
    end

    it "Bookと結び付いていないレコードたち" do
      lemon1
      assert { Lemon.single_only == [lemon1] } # Book と結び付いていないものたち
      book1
      assert { Lemon.single_only == [] } # Book と結び付いたので空
    end

    it "reset" do
      expect { lemon1.reset }.not_to raise_error
    end

    it "share_board_params" do
      assert { lemon1.share_board_params }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> .
# >>
# >> Top 1 slowest examples (1.36 seconds, 43.2% of total time):
# >>   Kiwi::Lemon Book を削除しても Lemon は削除されない
# >>     1.36 seconds -:82
# >>
# >> Finished in 3.14 seconds (files took 3.37 seconds to load)
# >> 1 example, 0 failures
# >>

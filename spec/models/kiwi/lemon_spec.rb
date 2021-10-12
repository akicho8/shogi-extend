# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 動画 (kiwi_lemons as Kiwi::Lemon)
#
# |------------------+--------------------------+-------------+-------------+----------------------------+-------|
# | name             | desc                     | type        | opts        | refs                       | index |
# |------------------+--------------------------+-------------+-------------+----------------------------+-------|
# | id               | ID                       | integer(8)  | NOT NULL PK |                            |       |
# | user_id          | 所有者                   | integer(8)  | NOT NULL    | => User#id                 | A     |
# | recordable_type  | 棋譜情報(クラス名)       | string(255) | NOT NULL    | SpecificModel(polymorphic) | B     |
# | recordable_id    | 棋譜情報                 | integer(8)  | NOT NULL    | => (recordable_type)#id    | B     |
# | all_params       | 変換用全パラメータ       | text(65535) | NOT NULL    |                            |       |
# | process_begin_at | 開始日時                 | datetime    |             |                            | C     |
# | process_end_at   | 終了日時(失敗時も入る)   | datetime    |             |                            | D     |
# | successed_at     | 正常終了日時             | datetime    |             |                            | E     |
# | errored_at       | 失敗終了日時             | datetime    |             |                            | F     |
# | error_message    | エラー文言               | text(65535) |             |                            |       |
# | content_type     | 動画タイプ               | string(255) |             |                            |       |
# | file_size        | 動画サイズ               | integer(4)  |             |                            |       |
# | ffprobe_info     | ffprobeの内容            | text(65535) |             |                            |       |
# | browser_path     | 動画WEBパス              | string(255) |             |                            |       |
# | filename_human   | 動画の人間向けファイル名 | string(255) |             |                            |       |
# | created_at       | 作成日時                 | datetime    | NOT NULL    |                            | G     |
# | updated_at       | 更新日時                 | datetime    | NOT NULL    |                            |       |
# |------------------+--------------------------+-------------+-------------+----------------------------+-------|
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

    it "Bananaと結び付いていないレコードたち" do
      lemon1
      assert { Lemon.single_only == [lemon1] } # Banana と結び付いていないものたち
      banana1
      assert { Lemon.single_only == [] } # Banana と結び付いたので空
    end

    it "reset" do
      expect { lemon1.reset }.not_to raise_error
    end

    it "advanced_kif_info" do
      assert { lemon1.advanced_kif_info }
    end

    it "jsonでBananaと結び付いているかわかる" do
      assert { lemon1.as_json(Lemon.json_struct_for_list)["banana"] == nil }
      banana1
      lemon1.reload
      assert { lemon1.as_json(Lemon.json_struct_for_list)["banana"] }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> F.........
# >> 
# >> Failures:
# >> 
# >>   1) Kiwi::Lemon 動画生成
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:49:in `block (2 levels) in <module:Kiwi>'
# >>      # ./spec/support/database_cleaner.rb:22:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:22:in `block (2 levels) in <main>'
# >> 
# >> Top 10 slowest examples (20.23 seconds, 91.9% of total time):
# >>   Kiwi::Lemon 動画生成
# >>     9.54 seconds -:38
# >>   Kiwi::Lemon ワーカー関係なく全処理実行
# >>     7.51 seconds -:57
# >>   Kiwi::Lemon advanced_kif_info
# >>     0.43673 seconds -:87
# >>   Kiwi::Lemon Bananaと結び付いていないレコードたち
# >>     0.4317 seconds -:76
# >>   Kiwi::Lemon reset
# >>     0.42067 seconds -:83
# >>   Kiwi::Lemon Bananaと結び付いているか確認
# >>     0.41513 seconds -:91
# >>   Kiwi::Lemon info
# >>     0.41146 seconds -:66
# >>   Kiwi::Lemon ワーカーが動いてなかったら動かす
# >>     0.40695 seconds -:52
# >>   Kiwi::Lemon 「みんな」の反映
# >>     0.36031 seconds -:71
# >>   Kiwi::Lemon ゾンビを成仏させる
# >>     0.29867 seconds -:62
# >> 
# >> Finished in 22.01 seconds (files took 3.41 seconds to load)
# >> 10 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:38 # Kiwi::Lemon 動画生成
# >> 

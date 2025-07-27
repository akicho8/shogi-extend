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
# [Warning: Need to add relation] Kiwi::Lemon モデルに belongs_to :recordable, polymorphic: true を追加してください
# [Warning: Need to add relation] Kiwi::Lemon モデルに belongs_to :user を追加してください
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Kiwi::Lemon, type: :model, kiwi: true do
  include KiwiSupport

  before do
    MediaBuilder.cache_delete_all   # => public/system/x-files/test を削除しておく
  end

  it "動画作成" do
    lemon1.main_process
    lemon1.reload

    assert { lemon1.status_key == "成功" }

    assert { lemon1.real_path.to_s.match?(/public/) }
    assert { lemon1.browser_path.match?(/system.*mp4/) }

    assert { lemon1.thumbnail_real_path.to_s.match?(/public.*thumbnail/) }
    assert { lemon1.thumbnail_browser_path.match?(/system.*thumbnail/) }
    assert { lemon1.thumbnail_real_path.exist? == false }
  end

  it "指定の時間内にワーカーが動いてなかったら動かす" do
    lemon1
    Kiwi::Lemon.background_job_kick_if_period(notify: true)
  end

  it "ワーカーが動いてなかったら動かす" do
    lemon1
    Kiwi::Lemon.background_job_kick
  end

  it "ワーカー関係なく全処理実行" do
    lemon1
    Kiwi::Lemon.background_job
  end

  it "ゾンビを成仏させる" do
    Kiwi::Lemon.zombie_kill
  end

  it "info" do
    lemon1
    assert { Kiwi::Lemon.info }
  end

  it "「みんな」の反映" do
    lemon1
    Kiwi::Lemon.everyone_broadcast
  end

  it "Bananaと結び付いていないレコードたち" do
    lemon1
    assert { Kiwi::Lemon.single_only == [lemon1] } # Banana と結び付いていないものたち
    banana1
    assert { Kiwi::Lemon.single_only == [] } # Banana と結び付いたので空
  end

  it "reset" do
    expect { lemon1.reset }.not_to raise_error
  end

  it "advanced_kif_info" do
    assert { lemon1.advanced_kif_info }
  end

  it "jsonでBananaと結び付いているかわかる" do
    assert { lemon1.as_json(Kiwi::Lemon.json_struct_for_list)["banana"] == nil }
    banana1
    lemon1.reload
    assert { lemon1.as_json(Kiwi::Lemon.json_struct_for_list)["banana"] }
  end

  it "ffmpegのssオプションで動画の長さを指定すると失敗するため「長さ-1」でclampする" do
    lemon1.main_process
    lemon1.reload
    assert { lemon1.duration == 6 }
    assert { lemon1.ffmpeg_ss_option_max == 5 }
    assert { lemon1.thumbnail_build_command(10).include?(" -ss 5 ") }
  end

  it "tag_list" do
    assert { lemon1.tag_list == ["居飛車"] }
  end

  it "古い動画を削除するとレコードと共にsystem以下の出力ファイルも消える" do
    lemon1.main_process
    lemon1.reload
    assert { lemon1.real_path.exist? }
    Kiwi::Lemon.cleanup(expires_in: 0, execute: true)
    assert { !lemon1.real_path.exist? }
    assert { !Kiwi::Lemon.exists?(lemon1.id) }
  end
end

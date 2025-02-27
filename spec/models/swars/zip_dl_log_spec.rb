# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xmode (swars_xmodes as Swars::Xmode)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | position   | 順序     | integer(4)  |             |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

require "rails_helper"

module Swars
  RSpec.describe ZipDlLog, type: :model do
    around do |e|
      # 本当は Object#with を使いたかった (ActiveRecord の with の方が使われて動かなかったため)
      stack = []
      stack << ZipDlLog.recent_period
      stack << ZipDlLog.recent_count_max
      e.call
      ZipDlLog.recent_count_max = stack.pop
      ZipDlLog.recent_period    = stack.pop
    end

    def case1
      @current_user = ::User.create!
      @swars_user = User.create!
      Battle.create! do |e|
        e.memberships.build(user: @swars_user)
      end
      @current_user.swars_zip_dl_logs.where(swars_user: @swars_user).create_by_battles!(@swars_user.battles.limit(1))
    end

    it "「前回の続きから」は end_at を見る" do
      case1
      assert { @current_user.swars_zip_dl_logs.continue_begin_at == "2000-01-01 00:00:01".to_time }
    end

    it "ダウンロード数判定が正しい" do
      case1
      ZipDlLog.recent_period    = 1.days                              # 期間1日内で、
      ZipDlLog.recent_count_max = 2                                   # 2件ダウンロードしたらもうだめとする
      assert { @current_user.swars_zip_dl_logs.recent_dl_total == 1 } # 現在1件ダウンロードしている
      assert { @current_user.swars_zip_dl_logs.downloadable? }        # まだダウンロードできる
      ZipDlLog.recent_count_max = 1                                   # 1件ダウンロードしたらもうだめとする
      assert { @current_user.swars_zip_dl_logs.download_prohibit? }   # 越えている (正確には 1 >= 1 の状態になっている)
      assert { @current_user.swars_zip_dl_logs.error_message }        # エラー文言は自分で作らなくていい
      ZipDlLog.recent_period = 0.days                                 # 仮に期間を 0 日とすれば条件の片方がはずれて
      assert { @current_user.swars_zip_dl_logs.downloadable? }        # まだダウンロードできる
    end
  end
end

# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Zip dl log (swars_zip_dl_logs as Swars::ZipDlLog)
#
# |---------------+------------+-------------+-------------+---------------------+-------|
# | name          | desc       | type        | opts        | refs                | index |
# |---------------+------------+-------------+-------------+---------------------+-------|
# | id            | ID         | integer(8)  | NOT NULL PK |                     |       |
# | user_id       | User       | integer(8)  | NOT NULL    | => ::User#id        | A     |
# | swars_user_id | Swars user | integer(8)  | NOT NULL    | => ::Swars::User#id | B     |
# | query         | Query      | string(255) | NOT NULL    |                     |       |
# | dl_count      | Dl count   | integer(4)  | NOT NULL    |                     |       |
# | begin_at      | Begin at   | datetime    | NOT NULL    |                     |       |
# | end_at        | End at     | datetime    | NOT NULL    |                     | C     |
# | created_at    | 作成日時   | datetime    | NOT NULL    |                     | D     |
# | updated_at    | 更新日時   | datetime    | NOT NULL    |                     |       |
# |---------------+------------+-------------+-------------+---------------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# 【警告:リレーション欠如】::Swars::Userモデルで has_many :swars/zip_dl_logs されていません
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Swars::ZipDlLog, type: :model do
  around do |e|
    # 本当は Swars::Object#with を使いたかった (ActiveRecord の with の方が使われて動かなかったため)
    stack = []
    stack << Swars::ZipDlLog.recent_period
    stack << Swars::ZipDlLog.recent_count_max
    e.call
    Swars::ZipDlLog.recent_count_max = stack.pop
    Swars::ZipDlLog.recent_period    = stack.pop
  end

  def case1
    @current_user = ::User.create!
    @swars_user = Swars::User.create!
    Swars::Battle.create! do |e|
      e.memberships.build(user: @swars_user)
    end
    @current_user.swars_zip_dl_logs.create_by_battles!(@swars_user.battles.limit(1))
  end

  it "「前回の続きから」は end_at を見る" do
    case1
    assert { @current_user.swars_zip_dl_logs.continue_begin_at == "2000-01-01 00:00:01".to_time }
  end

  it "ダウンロード数判定が正しい" do
    case1
    Swars::ZipDlLog.recent_period    = 1.days                       # 期間1日内で、
    Swars::ZipDlLog.recent_count_max = 2                            # 2件ダウンロードしたらもうだめとする
    assert { @current_user.swars_zip_dl_logs.recent_dl_total == 1 } # 現在1件ダウンロードしている
    assert { @current_user.swars_zip_dl_logs.downloadable? }        # まだダウンロードできる
    Swars::ZipDlLog.recent_count_max = 1                            # 1件ダウンロードしたらもうだめとする
    assert { @current_user.swars_zip_dl_logs.download_prohibit? }   # 越えている (正確には 1 >= 1 の状態になっている)
    assert { @current_user.swars_zip_dl_logs.error_message }        # エラー文言は自分で作らなくていい
    Swars::ZipDlLog.recent_period = 0.days                          # 仮に期間を 0 日とすれば条件の片方がはずれて
    assert { @current_user.swars_zip_dl_logs.downloadable? }        # まだダウンロードできる
  end
end

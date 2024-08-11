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
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
# 【警告:リレーション欠如】::Swars::Userモデルで has_many :swars/zip_dl_logs されていません
#--------------------------------------------------------------------------------

# rails r 'tp Swars::ZipDlLog'

module Swars
  class ZipDlLog < ApplicationRecord
    cattr_accessor(:recent_period)    { 1.days } # 直近のこの期間に
    cattr_accessor(:recent_count_max) { Rails.env.local? ? 100 : 1000 } # これを越えていると禁止 (DL数回数ではなくDLに含む棋譜総数)

    belongs_to :user,       class_name: "::User"        # ダウンロードしようとしている人
    belongs_to :swars_user, class_name: "::Swars::User" # ダウンロードされようとしている人

    scope :recent_only, -> (period = recent_period) { where(arel_table[:created_at].gt(period.ago)) } # 最近の period 期間のレコードたち

    class << self
      # 最近のDL総数
      def recent_dl_total
        recent_only.sum(:dl_count)
      end

      def error_message
        "直近#{recent_period / 1.hour}時間で #{recent_dl_total} 件もダウンロードしたのでもう無理です。しばらく時間を空けてから試してください。「前回の続きから」を使って差分だけを取得するとこの制限が出にくくなります。"
      end

      # 直近のダウンロード数が多すぎるか？
      def download_prohibit?
        dl_rest_count.zero?
      end

      # まだダウンロードできる？
      def downloadable?
        dl_rest_count.positive?
      end

      # 残りダウンロード可能件数
      def dl_rest_count
        [recent_count_max - recent_dl_total, 0].max
      end

      # 次にダウンロードを開始のはこの日時以降
      def continue_begin_at
        maximum(:end_at)
      end

      def create_by_battles!(battles, params = {})
        if battles.exists?
          a = battles.first.battled_at
          b = battles.last.battled_at
          a, b = [a, b].sort
          params = params.merge({
              :dl_count   => battles.count,
              :begin_at   => a,            # 単なる記録なのでなくてもよい
              :end_at     => b + 1.second, # 次はこの日時以上を対象にする
            })
          create!(params)
        end
      end
    end

    before_validation on: :create do
      self.query ||= ""
    end

    with_options presence: true do
      validates :begin_at
      validates :end_at
    end
  end
end

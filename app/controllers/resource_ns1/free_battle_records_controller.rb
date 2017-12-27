# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (free_battle_records as FreeBattleRecord)
#
# |--------------+--------------------+-------------+-------------+------+-------|
# | カラム名     | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |--------------+--------------------+-------------+-------------+------+-------|
# | id           | ID                 | integer(8)  | NOT NULL PK |      |       |
# | unique_key   | ユニークなハッシュ | string(255) | NOT NULL    |      | A     |
# | kifu_file    | 棋譜ファイル       | string(255) |             |      |       |
# | kifu_url     | 棋譜URL            | string(255) |             |      |       |
# | kifu_body    | 棋譜内容           | text(65535) | NOT NULL    |      |       |
# | turn_max     | 手数               | integer(4)  | NOT NULL    |      |       |
# | meta_info    | 棋譜ヘッダー       | text(65535) | NOT NULL    |      |       |
# | mountain_url | 将棋山脈URL        | string(255) |             |      |       |
# | battled_at   | Battled at         | datetime    | NOT NULL    |      |       |
# | created_at   | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at   | 更新日時           | datetime    | NOT NULL    |      |       |
# |--------------+--------------------+-------------+-------------+------+-------|

module ResourceNs1
  class FreeBattleRecordsController < ApplicationController
    include ModulableCrud::All
    include BattleRecordsController::SharedMethods

    private

    def current_filename
      Time.current.strftime("#{current_basename}_%Y_%m_%d_%H%M%S.#{params[:format]}")
    end

    def current_basename
      params[:basename].presence || "棋譜データ"
    end

    def raw_current_record
      if v = params[:id].presence
        current_scope.find_by!(unique_key: v)
      else
        current_scope.new
      end
    end

    def redirect_to_where
      current_record
    end

    def notice_message
    end

    def behavior_after_rescue(message)
      flash.now[:alert] = message
      render :edit
    end
  end
end

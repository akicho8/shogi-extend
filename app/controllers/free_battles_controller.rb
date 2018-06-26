# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (free_battles as FreeBattle)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | カラム名   | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      | A!    |
# | kifu_url   | 棋譜URL            | string(255) |             |      |       |
# | kifu_body  | 棋譜内容           | text(65535) | NOT NULL    |      |       |
# | turn_max   | 手数               | integer(4)  | NOT NULL    |      |       |
# | meta_info  | 棋譜ヘッダー       | text(65535) | NOT NULL    |      |       |
# | battled_at | Battled at         | datetime    | NOT NULL    |      |       |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

class FreeBattlesController < ApplicationController
  include ModulableCrud::All
  include SharedMethods

  def new
    @js_preview_params = {
      path: url_for([:free_battles, format: "json"]),
    }
    super
  end

  def create
    # プレビュー用
    if request.format.json?
      if v = params[:kifu_body]
        info = Warabi::Parser.parse(v, typical_error_case: :embed)
        render json: {sfen: info.to_sfen}
        return
      end
    end

    if url = current_record_params[:kifu_url].presence || current_record_params[:kifu_body].presence
      url
      if url.match?(%r{https?://kif-pona.heroz.jp/games/})
        key = URI(url).path.split("/").last
        redirect_to [:swars, :battle, id: key]
        return
      end
    end
    super
  end

  private

  def current_filename
    Time.current.strftime("#{current_basename}_%Y_%m_%d_%H%M%S.#{params[:format]}")
  end

  def current_basename
    params[:basename].presence || "棋譜データ"
  end

  def raw_current_record
    if v = params[:id].presence
      current_scope.find_by!(key: v)
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
    flash.now[:danger] = message
    render :edit
  end
end

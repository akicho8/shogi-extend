# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜入力 (free_battles as FreeBattle)
#
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | name              | desc               | type        | opts        | refs                              | index |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)  | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255) | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255) |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535) | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)  | NOT NULL    |                                   |       |
# | meta_info         | 棋譜ヘッダー       | text(65535) | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime    | NOT NULL    |                                   |       |
# | created_at        | 作成日時           | datetime    | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime    | NOT NULL    |                                   |       |
# | colosseum_user_id | Colosseum user     | integer(8)  |             | :owner_user => Colosseum::User#id | B     |
# | title             | タイトル           | string(255) |             |                                   |       |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# 【警告:リレーション欠如】Colosseum::Userモデルで has_many :free_battles, :foreign_key => :colosseum_user_id されていません
#--------------------------------------------------------------------------------

class FreeBattlesController < ApplicationController
  include ModulableCrud::All
  include SharedMethods

  let :js_preview_params do
    {
      path: url_for([:free_battles, format: "json"]),
    }
  end

  def create
    # プレビュー用
    if request.format.json?
      if v = params[:kifu_body]
        parsed_info = Warabi::Parser.parse(v, typical_error_case: :embed)
        render json: {
          sfen: parsed_info.to_sfen,
          kifu_infos: Warabi::KifuFormatInfo.collect { |e| { name: e.name, value: parsed_info.public_send("to_#{e.key}", compact: true) } } + [{name: "BOD", value: parsed_info.to_bod}],
        }
        return
      end
    end

    if url = current_record_params[:kifu_url].presence || current_record_params[:kifu_body].presence
      if key = Swars::Battle.extraction_key_from_dirty_string(url)
        redirect_to [:swars, :battle, id: key]
        return
      end
    end
    super
  end

  private

  def current_record_save
    current_record.owner_user ||= current_user
    super
  end

  def current_filename
    Time.current.strftime("#{current_basename}_%Y%m%d_%H%M%S.#{params[:format]}")
  end

  def current_basename
    params[:basename].presence || "棋譜データ"
  end

  def notice_message
  end

  def behavior_after_rescue(message)
    flash.now[:danger] = message
    render :edit
  end
end

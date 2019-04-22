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

  # free_battle_edit.js の引数用
  let :js_edit_params do
    {
      post_path: url_for([:free_battles, format: "json"]),
      record_attributes: current_record.as_json,
      output_kifs: output_kifs,
    }
  end

  let :current_kifu_body do
    params[:kifu_body].to_s
  end

  let :heavy_parsed_info do
    Bioshogi::Parser.parse(current_kifu_body, typical_error_case: :embed)
  end

  let :output_kifs do
    KifuFormatWithBodInfo.inject({}) { |a, e| a.merge(e.key => { key: e.key, name: e.name, value: heavy_parsed_info.public_send("to_#{e.key}", compact: true) }) }
  end

  def new
    if id = params[:source_id]
      record = FreeBattle.find(id)
      flash[:source_id] = record.id
      redirect_to [:new, ns_prefix, current_single_key], notice: "#{record.title}の棋譜をコピペしました"
      return
    end

    super
  end

  def create
    # プレビュー用
    if request.format.json?
      if v = params[:kifu_body]
        render json: { output_kifs: output_kifs }
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

  def current_record_params
    v = super
    if id = flash[:source_id]
      record = FreeBattle.find(id)
      v[:kifu_body] = record.kifu_body
      v[:title] = "#{record.title}のコピー"
    end
    v
  end

  def current_record_save
    current_record.owner_user ||= current_user
    super
  end

  def current_filename
    "#{current_record.download_filename}.#{params[:format]}"
    # Time.current.strftime("#{current_basename}_%Y%m%d_%H%M%S.#{params[:format]}")
  end

  def current_basename
    params[:basename].presence || current_basename_default
  end

  def current_basename_default
    "棋譜データ"
  end

  def notice_message
  end

  def behavior_after_rescue(message)
    flash.now[:danger] = message
    render :edit
  end
end

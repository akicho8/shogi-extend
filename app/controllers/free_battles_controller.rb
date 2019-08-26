# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+--------------+-------------+-----------------------------------+-------|
# | name              | desc               | type         | opts        | refs                              | index |
# |-------------------+--------------------+--------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)   | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255)  | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255)  |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535)  | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)   | NOT NULL    |                                   | D     |
# | meta_info         | 棋譜ヘッダー       | text(65535)  | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime     | NOT NULL    |                                   | C     |
# | created_at        | 作成日時           | datetime     | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime     | NOT NULL    |                                   |       |
# | colosseum_user_id | 所有者ID           | integer(8)   |             | :owner_user => Colosseum::User#id | B     |
# | title             | 題名               | string(255)  |             |                                   |       |
# | description       | 説明               | text(65535)  | NOT NULL    |                                   |       |
# | start_turn        | 開始手数           | integer(4)   |             |                                   |       |
# | critical_turn     | 開戦               | integer(4)   |             |                                   | E     |
# | saturn_key        | Saturn key         | string(255)  | NOT NULL    |                                   | F     |
# | sfen_body         | Sfen body          | string(8192) |             |                                   |       |
# | image_turn        | OGP画像の手数      | integer(4)   |             |                                   |       |
# |-------------------+--------------------+--------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class FreeBattlesController < ApplicationController
  include ModulableCrud::All
  include BattleControllerBaseMethods
  include BattleControllerSharedMethods

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
      if v = params[:input_any_kifu]
        render json: { output_kifs: output_kifs, turn_max: turn_max }
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

  let :current_record do
    if params[:id]
      record = current_model.find(params[:id])
    else
      record = current_model.new
    end
    record.tap do |e|
      # 初期値設定
      if current_user
        e.saturn_key ||= SaturnInfo.fetch(:private).key
      else
        e.saturn_key ||= SaturnInfo.fetch(:public).key
      end
    end
  end

  def current_record_params
    v = super

    if id = flash[:source_id]
      record = FreeBattle.find(id)
      v[:kifu_body] = record.kifu_body
      v[:title] = "「#{record.title}」のコピー"
      v[:description] = record.description
      v[:start_turn] = record.start_turn
    end

    if hidden_kifu_body = v.delete(:hidden_kifu_body)
      v[:kifu_body] = hidden_kifu_body
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

  def behavior_after_rescue(message)
    flash.now[:danger] = message
    render :edit
  end

  def redirect_to_where
    if false
      # 自動的にOGP画像設定に移動する場合
      if current_record.saved_changes[:id]
        if editable_record?(current_record)
          return [:edit, ns_prefix, current_record, mode: :ogp]
        end
      end
    end

    if false
      # if current_record.saved_changes[:id]
      if editable_record?(current_record)
        return [:edit, ns_prefix, current_record, mode: :ogp, auto_write: true]
      end
      # end
    end

    super
  end

  concerning :EditCustomMethods do
    included do
      helper_method :js_edit_options
    end

    # free_battle_edit.js の引数用
    let :js_edit_options do
      {
        post_path: url_for([:free_battles, format: "json"]),
        record_attributes: current_record.as_json,
        output_kifs: output_kifs,
        new_path: polymorphic_path([:new, :free_battle]),
        saturn_info: SaturnInfo.inject({}) { |a, e| a.merge(e.key => e.attributes) },
      }
    end

    private

    def output_kifs
      @output_kifs ||= KifuFormatWithBodInfo.inject({}) { |a, e| a.merge(e.key => { key: e.key, name: e.name, value: heavy_parsed_info.public_send("to_#{e.key}", compact: true) }) }
    end

    def turn_max
      @turn_max ||= heavy_parsed_info.mediator.turn_info.turn_max
    end

    def heavy_parsed_info
      @heavy_parsed_info ||= Bioshogi::Parser.parse(current_input_any_kifu, typical_error_case: :embed, support_for_piyo_shogi_v4_1_5: false)
    end

    def current_input_any_kifu
      params[:input_any_kifu].to_s
    end
  end

  concerning :IndexCustomMethods do
    let :table_columns_hash do
      list = []
      unless Rails.env.production?
        list << { key: :id,               label: "ID",   visible: false, }
      end
      list += [
        { key: :created_at,        label: "作成日時", visible: false, },
        { key: :turn_max,          label: "手数",     visible: false, },
        { key: :colosseum_user_id, label: "所有者",   visible: false, },
      ]
    end

    def js_record_for(e)
      a = super

      a[:title] = e.title
      a[:description] = e.description

      if e.owner_user
        a[:owner_info] = { name: e.owner_user.name, url: url_for(e.owner_user) }
      end

      a[:formated_created_at] = h.time_ago_in_words(e.created_at) + "前"
      a[:new_and_copy_url] = url_for([:new, ns_prefix, current_single_key, source_id: e.id])

      a
    end
  end
end

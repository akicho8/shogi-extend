# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
# | name              | desc               | type           | opts        | refs                              | index |
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)     | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255)    | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255)    |             |                                   |       |
# | kifu_body         | 棋譜               | text(16777215) |             |                                   |       |
# | turn_max          | 手数               | integer(4)     | NOT NULL    |                                   | D     |
# | meta_info         | 棋譜ヘッダー       | text(16777215) | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime       | NOT NULL    |                                   | C     |
# | created_at        | 作成日時           | datetime       | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime       | NOT NULL    |                                   |       |
# | colosseum_user_id | 所有者ID           | integer(8)     |             | :owner_user => Colosseum::User#id | B     |
# | title             | 題名               | string(255)    |             |                                   |       |
# | description       | 説明               | text(16777215) | NOT NULL    |                                   |       |
# | start_turn        | 開始局面           | integer(4)     |             |                                   |       |
# | critical_turn     | 開戦               | integer(4)     |             |                                   | E     |
# | saturn_key        | 公開範囲           | string(255)    | NOT NULL    |                                   | F     |
# | sfen_body         | SFEN形式棋譜       | string(8192)   |             |                                   |       |
# | image_turn        | OGP画像の局面      | integer(4)     |             |                                   |       |
# | use_key           | Use key            | string(255)    | NOT NULL    |                                   |       |
# | outbreak_turn     | Outbreak turn      | integer(4)     |             |                                   |       |
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class FreeBattlesController < ApplicationController
  include ModulableCrud::All
  include BattleControllerBaseMethods
  include BattleControllerSharedMethods
  include AdapterMod

  def new
    if id = params[:source_id]
      record = FreeBattle.find_by!(key: id)
      flash[:source_id] = record.to_param
      redirect_to [:new, ns_prefix, current_single_key], notice: "#{record.safe_title}の棋譜をコピペしました"
      return
    end

    super
  end

  def create
    if request.format.json?
      if params[:input_text]
        # なんでも棋譜変換
        if current_edit_mode === :adapter
          adapter_process
          if performed?
            return
          end
        end

        # プレビュー用
        if current_edit_mode === :basic
          render json: { output_kifs: output_kifs, turn_max: turn_max }
          return
        end
      end
    end

    # 本文に将棋ウォーズのURLが含まれているとウォーズ検索の方に飛ばす
    # この機能はウォーズの棋譜をコピーして投稿しようとしたときに意図せず発動してしまうため禁止にする
    if false
      if url = current_record_params[:kifu_url].presence || current_record_params[:kifu_body].presence
        if key = Swars::Battle.battle_key_extract(url)
          redirect_to [:swars, :battle, id: key]
          return
        end
      end
    end

    super
  end

  private

  def access_log_create(record)
    record.update!(updated_at: Time.current)
  end

  def current_index_scope
    @current_index_scope ||= -> {
      s = current_scope
      if modal_record
        s = s.unscoped.where(key: modal_record.key)
      end
      s
    }.call
  end

  let :current_record do
    record = nil

    if id = params[:id]
      if Rails.env.production? || Rails.env.staging?
      else
        record ||= current_model.find_by(id: id)
      end
      record ||= current_model.find_by!(key: id)
    end

    record ||= current_model.new

    record.tap do |e|
      # 初期値設定

      if current_edit_mode == :adapter
        e.saturn_key ||= SaturnInfo.fetch(:private).key
        e.use_key ||= UseInfo.fetch(:adapter).key
      else
        e.use_key ||= UseInfo.fetch(:basic).key
        if current_user
          e.saturn_key ||= SaturnInfo.fetch(:private).key
        else
          e.saturn_key ||= SaturnInfo.fetch(:public).key
        end
      end
    end
  end

  def current_record_params
    v = super

    if id = flash[:source_id]
      record = current_model.find_by!(key: id)
      v[:kifu_body] = record.kifu_body
      v[:title] = "「#{record.safe_title}」のコピー"
      v[:description] = record.description
      v[:start_turn] = record.start_turn
    end

    if hidden_kifu_body = v.delete(:hidden_kifu_body)
      v[:kifu_body] = hidden_kifu_body
    end

    v
  end

  def current_record_save
    if current_record.use_info.key == :basic
      current_record.owner_user ||= current_user
    end
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
    # 自動的にOGP画像設定に移動する場合
    if false
      if current_record.saved_changes[:id]
        if editable_record?(current_record)
          return [:edit, ns_prefix, current_record, edit_mode: :ogp]
        end
      end
    end

    # 自動的にOGP画像設定する場合
    if true
      if current_record.saved_changes[:image_turn]
        if editable_record?(current_record)
          return [:edit, ns_prefix, current_record, edit_mode: :ogp, auto_write: true]
        end
      end
    end

    super
  end

  concerning :IndexCustomMethods do
    let :table_column_list do
      list = []
      if Rails.env.production? || Rails.env.staging?
      else
        list << { key: :key,       label: "KEY",      visible: false, }
      end
      list += [
        { key: :created_at,        label: "作成日時", visible: false, },
        { key: :turn_max,          label: "手数",     visible: false, },
        { key: :colosseum_user_id, label: "所有者",   visible: false, },
      ]
    end

    def js_record_for(e)
      a = super

      a[:tweet_origin_image_path] = e.tweet_origin_image_path
      a[:tweet_body] = e.tweet_body
      a[:tweet_window_url] = e.tweet_window_url

      a[:title] = e.title
      a[:description] = e.description

      if e.owner_user
        a[:owner_info] = { name: e.owner_user.name, url: url_for(e.owner_user) }
      end

      a[:formated_created_at] = h.time_ago_in_words(e.created_at) + "前"
      a[:new_and_copy_url] = url_for([:new, ns_prefix, current_single_key, source_id: e.to_param])

      a
    end
  end
end

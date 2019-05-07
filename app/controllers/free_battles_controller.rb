# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | name              | desc               | type        | opts        | refs                              | index |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)  | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255) | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255) |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535) | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)  | NOT NULL    |                                   | D     |
# | meta_info         | 棋譜ヘッダー       | text(65535) | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime    | NOT NULL    |                                   | C     |
# | created_at        | 作成日時           | datetime    | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime    | NOT NULL    |                                   |       |
# | colosseum_user_id | Colosseum user     | integer(8)  |             | :owner_user => Colosseum::User#id | B     |
# | title             | タイトル           | string(255) |             |                                   |       |
# | description       | 備考               | text(65535) | NOT NULL    |                                   |       |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class FreeBattlesController < ApplicationController
  include ModulableCrud::All
  include BattleActionSharedMethods1

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
      v[:title] = "「#{record.title}」のコピー"
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

  def notice_message
  end

  def behavior_after_rescue(message)
    flash.now[:danger] = message
    render :edit
  end

  concerning :EditCustomMethods do
    included do
      # free_battle_edit.js の引数用
      let :js_edit_options do
        {
          post_path: url_for([:free_battles, format: "json"]),
          record_attributes: current_record.as_json,
          output_kifs: output_kifs,
          new_path: polymorphic_path([:new, :free_battle]),
        }
      end

      let :current_input_any_kifu do
        params[:input_any_kifu].to_s
      end

      let :heavy_parsed_info do
        Bioshogi::Parser.parse(current_input_any_kifu, typical_error_case: :embed)
      end

      let :output_kifs do
        KifuFormatWithBodInfo.inject({}) { |a, e| a.merge(e.key => { key: e.key, name: e.name, value: heavy_parsed_info.public_send("to_#{e.key}", compact: true) }) }
      end
    end
  end

  concerning :ShowMethods do
    included do
      let :twitter_options do
        options = {
          title: current_record.safe_title,
          url: current_record.tweet_page_url2,
        }
        if current_record.respond_to?(:description) && v = current_record.description.presence
          options[:description] = v
        end
        if twitter_staitc_image_url
          options.update(image: twitter_staitc_image_url)
        else
          options.update(card: "summary")
        end
        options
      end

      let :twitter_staitc_image_url do
        if current_record.thumbnail_image.attached?
          # rails_representation_url(current_record.thumbnail_image.variant(resize: "1200x630!", type: :grayscale))
          # とした場合はリダイレクトするURLになってしまうため使えない
          # 固定URL化する
          polymorphic_url([ns_prefix, current_record], format: "png", updated_at: current_record.updated_at.to_i)
        end
      end
    end
  end

  include BattleActionSharedMethods2

  concerning :IndexCustomMethods do
    included do
      let :table_columns_hash do
        [
          { key: :id,                label: "ID",       visible: false, },
          { key: :created_at,        label: "作成日時", visible: false, },
          { key: :turn_max,          label: "手数",     visible: false, },
          { key: :colosseum_user_id, label: "所有者",   visible: false, },
        ]
      end
    end

    def js_current_records_one(e)
      a = e.attributes
      a[:kifu_copy_params] = e.to_kifu_copy_params(view_context)
      a[:sp_sfen_get_path] = polymorphic_path([ns_prefix, e], format: "json")
      a[:piyo_shogi_app_url] = piyo_shogi_app_url(full_url_for([e, format: "kif"]))

      if e.owner_user
        a[:owner_info] = { name: e.owner_user.name, url: url_for(e.owner_user) }
      end

      a[:formated_created_at] = h.time_ago_in_words(e.created_at) + "前"

      a[:show_url_info] = { name: "詳細", url: polymorphic_path([ns_prefix, e]) }

      if editable_record?(e) || Rails.env.development?
        a[:edit_url_info] = { name: "編集", url: polymorphic_path([:edit, ns_prefix, e]) }
      end

      a[:new_and_copy] = { name: "新規でコピペ", url: url_for([:new, ns_prefix, current_single_key, source_id: e.id]) }

      a[:tweet_image_url] = e.tweet_image_url

      a
    end
  end
end

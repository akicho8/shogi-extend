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
# | description       | 備考               | text(65535) | NOT NULL    |                                   |       |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class FreeBattlesController < ApplicationController
  include ModulableCrud::All
  include SharedMethods

  cattr_accessor(:saisyoniload) { false }

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
    if request.xhr?
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

  concerning :IndexSharedMethods do
    included do
      let :current_query do
        params[:query].presence
      end

      let :current_records do
        current_scope.select(current_model.column_names - ["meta_info"]).page(params[:page]).per(current_per)
      end

      let :current_per do
        (params[:per].presence || (Rails.env.production? ? 25 : 25)).to_i
      end

      let :current_sort_column do
        params[:sort_column].presence || default_sort_column
      end

      let :default_sort_column do
        "created_at"
      end

      let :current_sort_order do
        params[:sort_order].presence || "desc"
      end

      let :current_placeholder do
        ""
      end

      let :pure_current_scope do
        current_model.all
      end

      let :current_scope do
        s = pure_current_scope
        if r = current_ransack
          s = s.merge(r.result)
        end
        if current_sort_column && current_sort_order
          s = s.order(current_sort_column => current_sort_order)
        end
        s = s.order(id: :desc)
        s
      end

      let :current_ransack do
        if current_query
          current_model.ransack(title_or_description_cont: current_query)
        end
      end

      let :js_index_options do
        {
          query: current_query || "",
          xhr_index_path: polymorphic_path([ns_prefix, current_plural_key], format: "json"),
          total: current_records.total_count,
          page: current_records.current_page,
          per: current_per,
          sort_column: current_sort_column,
          sort_order: current_sort_order,
          sort_order_default: "desc", # カラムをクリックしたときの最初の向き
          # records: js_current_records,
          records: [],
          table_columns_hash: Rails.env.production? ? table_columns_hash : table_columns_hash.transform_values { |e| e.merge(visible: true) },
        }
      end
    end

    def show
      if request.xhr?
        render json: { sp_sfen: current_record.sfen }
        return
      end

      super
    end
  end

  concerning :IndexCustomMethods do
    included do
      let :table_columns_hash do
        {
          created_at:        { label: "作成日時", visible: false, },
          turn_max:          { label: "手数",     visible: false, },
          colosseum_user_id: { label: "所有者",   visible: false, },
        }
      end

      let :js_current_records do
        current_records.collect do |e|
          e.as_json.tap do |a|
            a[:kifu_copy_params] = e.to_kifu_copy_params(view_context)
            a[:xhr_get_path] = polymorphic_path([ns_prefix, e], format: "json")

            if e.owner_user
              a[:owner_user_link_html] = link_to(e.owner_user.name, e.owner_user)
            end

            a[:created_at_html] = h.time_ago_in_words(e.created_at) + "前"

            list = []
            list << link_to("詳細", [ns_prefix, e], :class => "button is-small")
            if editable_record?(e) || Rails.env.development?
              list << link_to("編集", [:edit, ns_prefix, e], :class => "button is-small")
            end
            a[:controls_html] = list.join(" ")
          end
        end
      end
    end
  end
end

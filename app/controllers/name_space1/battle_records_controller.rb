# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as BattleRecord)
#
# |--------------------+--------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味               | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+--------------------+-------------+-------------+------------------+-------|
# | id                 | ID                 | integer(8)  | NOT NULL PK |                  |       |
# | unique_key         | ユニークなハッシュ | string(255) | NOT NULL    |                  |       |
# | battle_key         | Battle key         | string(255) | NOT NULL    |                  |       |
# | battled_at         | Battled at         | datetime    | NOT NULL    |                  |       |
# | game_type_key      | Game type key      | string(255) | NOT NULL    |                  |       |
# | csa_hands          | Csa hands          | text(65535) | NOT NULL    |                  |       |
# | reason_key         | Reason key         | string(255) | NOT NULL    |                  |       |
# | win_battle_user_id | Win battle user    | integer(8)  |             | => BattleUser#id | A     |
# | turn_max           | 手数               | integer(4)  |             |                  |       |
# | kifu_header        | 棋譜ヘッダー       | text(65535) |             |                  |       |
# | created_at         | 作成日時           | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時           | datetime    | NOT NULL    |                  |       |
# |--------------------+--------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

module NameSpace1
  class BattleRecordsController < ApplicationController
    if Rails.env.production?
      if v = ENV["HTTP_BASIC_AUTHENTICATE"].presence
        http_basic_authenticate_with Hash[[:name, :password].zip(v.split(/:/))].merge(only: [:index, :edit, :update, :destroy])
      end
    end

    include ModulableCrud::All

    def show
      respond_to do |format|
        format.html
        format.kif { kifu_send_data }
        format.ki2 { kifu_send_data }
        format.csa { kifu_send_data }
      end
    end

    private

    def raw_current_record
      if v = params[:id].presence
        BattleRecord.import_by_battle_key(v)
        current_scope.find_by!(battle_key: v)
      else
        current_scope.new
      end
    end

    # def redirect_to_where
    #   [self.class.parent_name.underscore, current_record]
    # end

    def notice_message
      "変換完了！"
    end

    def kifu_send_data
      filename = Time.current.strftime("#{current_filename}_%Y_%m_%d_%H%M%S.#{params[:format]}").encode(current_encode)
      converted_info = current_record.converted_infos.find_by!(converted_format: params[:format])
      send_data(converted_info.converted_body, type: Mime[params[:format]], filename: filename, disposition: true ? "inline" : "attachment")
    end

    def current_filename
      params[:filename].presence || "棋譜データ"
    end

    def current_encode
      params[:encode].presence || current_encode_default
    end

    def current_encode_default
      if request.user_agent.to_s.match(/Windows/i)
        "Shift_JIS"
      else
        "UTF-8"
      end
    end

    rescue_from "Bushido::BushidoError" do |exception|
      h = ApplicationController.helpers
      lines = exception.message.lines
      message = lines.first.strip.html_safe
      if field = lines.drop(1).join.presence
        message += "<br>".html_safe
        message += h.content_tag(:pre, field).html_safe
      end
      unless Rails.env.production?
        if exception.backtrace
          message += h.content_tag(:pre, exception.backtrace.first(8).join("\n").html_safe).html_safe
        end
      end
      flash.now[:alert] = message
      render :edit
    end
  end
end

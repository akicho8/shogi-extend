# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (wars_records as WarsRecord)
#
# |---------------+--------------------+----------+-------------+------+-------|
# | カラム名      | 意味               | タイプ   | 属性        | 参照 | INDEX |
# |---------------+--------------------+----------+-------------+------+-------|
# | id            | ID                 | integer  | NOT NULL PK |      |       |
# | unique_key    | ユニークなハッシュ | string   | NOT NULL    |      |       |
# | battle_key    | Battle key         | string   | NOT NULL    |      |       |
# | battled_at    | Battled at         | datetime | NOT NULL    |      |       |
# | game_type_key | Game type key      | string   | NOT NULL    |      |       |
# | csa_hands     | Csa hands          | text     | NOT NULL    |      |       |
# | converted_ki2 | 変換後KI2          | text     |             |      |       |
# | converted_kif | 変換後KIF          | text     |             |      |       |
# | converted_csa | 変換後CSA          | text     |             |      |       |
# | turn_max      | 手数               | integer  |             |      |       |
# | kifu_header   | 棋譜ヘッダー       | text     |             |      |       |
# | created_at    | 作成日時           | datetime | NOT NULL    |      |       |
# | updated_at    | 更新日時           | datetime | NOT NULL    |      |       |
# |---------------+--------------------+----------+-------------+------+-------|

module NameSpace1
  class WarsRecordsController < ApplicationController
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
      send_data(current_record.send("converted_#{params[:format]}"), type: Mime[params[:format]], filename: filename, disposition: true ? "inline" : "attachment")
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

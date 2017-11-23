# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (kifu_convert_infos as KifuConvertInfo)
#
# |---------------+--------------------+----------+-------------+------+-------|
# | カラム名      | 意味               | タイプ   | 属性        | 参照 | INDEX |
# |---------------+--------------------+----------+-------------+------+-------|
# | id            | ID                 | integer  | NOT NULL PK |      |       |
# | unique_key    | ユニークなハッシュ | string   | NOT NULL    |      |       |
# | kifu_file     | 棋譜ファイル       | string   |             |      |       |
# | kifu_url      | 棋譜URL            | string   |             |      |       |
# | kifu_body     | 棋譜内容           | text     |             |      |       |
# | converted_ki2 | 変換後KI2          | text     |             |      |       |
# | converted_kif | 変換後KIF          | text     |             |      |       |
# | converted_csa | 変換後CSA          | text     |             |      |       |
# | turn_max      | 手数               | integer  |             |      |       |
# | kifu_header   | 棋譜ヘッダー       | text     |             |      |       |
# | created_at    | 作成日時           | datetime | NOT NULL    |      |       |
# | updated_at    | 更新日時           | datetime | NOT NULL    |      |       |
# |---------------+--------------------+----------+-------------+------+-------|

module NameSpace1
  class KifuConvertInfosController < ApplicationController
    if Rails.env.production?
      if v = ENV["HTTP_BASIC_AUTHENTICATE"].presence
        http_basic_authenticate_with Hash[[:name, :password].zip(v.split(/:/))].merge(only: [:index, :edit, :update, :destroy])
      end
    end

    include PluggableCrud::All

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
        current_scope.find_by!(unique_key: v)
      else
        current_scope.new
      end
      # if Rails.env.development?
      # e.kifu_url ||= "#{current_model.maximum(:id).to_i.next}つめ"
      # e.kifu_body ||= "▲2六歩 ▽3四歩 ▲2五歩 ▽3三角 ▲7六歩 ▽4二銀 ▲4八銀 ▽5四歩 ▲6八玉 ▽5五歩"
    end

    # 更新後の移動先
    def redirect_to_where
      current_record
      # [self.class.parent_name.underscore, current_record]
    end

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

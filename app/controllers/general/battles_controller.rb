# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (general_battles as General::Battle)
#
# |-----------------+-----------------+--------------+-------------+------+-------|
# | name            | desc            | type         | opts        | refs | index |
# |-----------------+-----------------+--------------+-------------+------+-------|
# | id              | ID              | integer(8)   | NOT NULL PK |      |       |
# | key             | 対局キー        | string(255)  | NOT NULL    |      | A!    |
# | battled_at      | 対局日          | datetime     |             |      | C     |
# | kifu_body       | 棋譜内容        | text(65535)  | NOT NULL    |      |       |
# | final_key       | 結果            | string(255)  | NOT NULL    |      | B     |
# | turn_max        | 手数            | integer(4)   | NOT NULL    |      | D     |
# | meta_info       | 棋譜ヘッダー    | text(65535)  | NOT NULL    |      |       |
# | last_accessd_at | Last accessd at | datetime     | NOT NULL    |      |       |
# | created_at      | 作成日時        | datetime     | NOT NULL    |      |       |
# | updated_at      | 更新日時        | datetime     | NOT NULL    |      |       |
# | start_turn      | 開始手数        | integer(4)   |             |      |       |
# | critical_turn   | 開戦            | integer(4)   |             |      | E     |
# | saturn_key      | Saturn key      | string(255)  | NOT NULL    |      | F     |
# | sfen_body       | Sfen body       | string(8192) |             |      |       |
# | image_turn      | OGP画像の手数   | integer(4)   |             |      |       |
# |-----------------+-----------------+--------------+-------------+------+-------|

module General
  class BattlesController < ApplicationController
    include ModulableCrud::All

    legacy_let :current_record do
      if v = params[:id].presence
        current_scope.find_by!(key: v)
      else
        current_scope.new
      end
    end

    legacy_let :current_query do
      params[:query].presence
    end

    legacy_let :current_scope do
      s = current_model
      if v = current_query
        s = s.tagged_with(v)
      end
      s.order(battled_at: :desc)
    end

    legacy_let :current_records do
      current_scope.page(params[:page]).per(params[:per])
    end

    legacy_let :rows do
      current_records.collect do |battle|
        {}.tap do |row|
          row["ID"] = link_to("##{battle.to_param}", battle)
          row.update(["▲", "△"].zip(battle.memberships.collect{|e|membership_name(e)}).to_h)
          row["結果"] = battle.final_info.name
          row["手数"] = battle.turn_max
          row["日時"] = battle.date_link(h, battle.meta_info[:header]["開始日時"])
          row[""] = row_links(battle)
        end
      end
    end

    def membership_name(membership)
      meta_info = membership.battle.meta_info
      names = meta_info[:detail_names][membership.location.code]

      # 詳細になかったら「先手」「後手」のところから探す
      if names.blank?
        names = meta_info[:simple_names][membership.location.code].flatten
      end

      if names.blank?
        return "不明"
      end

      names.collect {|e|
        link_to(e, general_search_path(e))
      }.join(" ").html_safe
    end

    private

    def row_links(battle)
      list = []
      list << link_to("詳細", [battle], "class": "button is-small")
      list.compact.join(" ").html_safe
    end

    def general_user_link(battle, judge_key)
      if membership = battle.memberships.judge_key_eq(judge_key)
        membership_name(membership)
      end
    end

    rescue_from "ActiveRecord::RecordNotFound" do |exception|
      redirect_to [:general, :battles], alert: "見つかりませんでした"
    end
  end
end

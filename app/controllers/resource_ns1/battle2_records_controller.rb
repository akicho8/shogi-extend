# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle2_records as Battle2Record)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | カラム名          | 意味              | タイプ      | 属性        | 参照 | INDEX |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | battle_key        | Battle key        | string(255) | NOT NULL    |      | A!    |
# | battled_at        | Battled at        | datetime    |             |      |       |
# | kifu_body         | 棋譜内容          | text(65535) | NOT NULL    |      |       |
# | battle2_state_key | Battle2 state key | string(255) | NOT NULL    |      | B     |
# | turn_max          | 手数              | integer(4)  | NOT NULL    |      |       |
# | meta_info         | 棋譜ヘッダー      | text(65535) | NOT NULL    |      |       |
# | mountain_url      | 将棋山脈URL       | string(255) |             |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      |       |
# |-------------------+-------------------+-------------+-------------+------+-------|

module ResourceNs1
  class Battle2RecordsController < ApplicationController
    include ModulableCrud::All
    include BattleRecordsController::SharedMethods

    def index
      @battle2_records = Battle2Record.all

      if v = current_plus_tags.presence
        @battle2_records = @battle2_records.tagged_with(v)
      end
      if v = current_minus_tags.presence
        @battle2_records = @battle2_records.tagged_with(v, exclude: true)
      end

      @battle2_records = @battle2_records.order(battled_at: :desc)

      if true
        if request.format.zip?
          filename = -> {
            parts = []
            parts << "2chkifu"
            if current_user
              parts << current_user.name
            end
            parts << Time.current.strftime("%Y%m%d%H%M%S")
            parts.concat(current_tags)
            parts.compact.join("_") + ".zip"
          }

          zip_buffer = Zip::OutputStream.write_buffer do |zos|
            @battle2_records.limit(params[:limit] || 512).each do |battle2_record|
              KifuFormatInfo.each.with_index do |e|
                if converted_info = battle2_record.converted_infos.text_format_eq(e.key).take
                  zos.put_next_entry("#{e.key}/#{battle2_record.battle_key}.#{e.key}")
                  zos.write converted_info.text_body
                end
              end
            end
          end

          send_data(zip_buffer.string, type: Mime[params[:format]], filename: filename.call, disposition: "attachment")
          return
        end
      end

      @battle2_records = @battle2_records.page(params[:page]).per(params[:per])

      @rows = @battle2_records.collect do |battle2_record|
        {}.tap do |row|

          if current_user
            l_ship = battle2_record.myself(current_user)
            r_ship = battle2_record.rival(current_user)
          else
            if battle2_record.battle2_state_info.draw
              l_ship = battle2_record.battle2_ships.black
              r_ship = battle2_record.battle2_ships.white
            else
              l_ship = battle2_record.battle2_ships.judge_key_eq(:win)
              r_ship = battle2_record.battle2_ships.judge_key_eq(:lose)
            end
          end

          if current_user
            row["対象棋士"] = battle2_record.win_lose_str(l_ship).html_safe + " " + h.battle2_user_link2(l_ship)
            row["対戦相手"]       = battle2_record.win_lose_str(r_ship).html_safe + " " + h.battle2_user_link2(r_ship)
          else
            if battle2_record.battle2_state_info.draw
              row["勝ち"] = Fa.icon_tag(:minus, :class => "icon_hidden") + h.battle2_user_link2(l_ship)
              row["負け"] = Fa.icon_tag(:minus, :class => "icon_hidden") + h.battle2_user_link2(r_ship)
            else
              row["勝ち"] = Fa.icon_tag(:circle_o) + h.battle2_user_link2(l_ship)
              row["負け"] = Fa.icon_tag(:times)    + h.battle2_user_link2(r_ship)
            end
          end

          row["判定"] = battle2_state_info_decorate(battle2_record)

          row[pc_only("戦型対決")] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
          row[pc_only("囲い対決")] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))

          row["手数"]   = link_to(battle2_record.turn_max, resource_ns1_general_search_path(battle2_record.turn_max))
          row["手合割"] = battle2_record.teaiwari_link(h, battle2_record.meta_info[:header]["手合割"])
          row["日時"]   = battle2_record.date_link(h, battle2_record.meta_info[:header]["開始日時"])

          row[""] = row_links(battle2_record)
        end
      end
    end

    def current_tags
      @current_tags ||= -> {
        s = params[:query].to_s.gsub(/\p{blank}/, " ").strip
        s = s.split(/\s+/)
        s.uniq
      }.call
    end

    def current_plus_tags
      @current_plus_tags ||= current_tags.find_all { |e| !e.start_with?("-") }
    end

    def current_minus_tags
      @current_minus_tags ||= current_tags.collect { |e|
        if e.start_with?("-")
          e.remove(/^-/)
        end
      }.compact
    end

    def current_form_search_value
      current_tags.join(" ")
    end

    def current_tactics
      @current_tactics ||= current_tags.find_all { |tag| Bushido::TacticInfo.any? { |e| e.model[tag] } }
    end

    def current_user
      @current_user ||= -> {
        v = nil
        current_tags.each do |e|
          if v = Battle2User.find_by(name: e)
            break
          end
        end
        v
      }.call
    end

    private

    def raw_current_record
      if v = params[:id].presence
        current_scope.find_by!(battle_key: v)
      else
        current_scope.new
      end
    end

    def pc_only(v)
      tag.span(v, :class => "visible-lg")
    end

    def versus_tag(*list)
      list = list.compact
      if list.present?
        vs = tag.span(" vs ", :class => "text-muted")
        str = list.collect { |e| e || "不明" }.join(vs).html_safe
        pc_only(str)
      end
    end

    def tag_links(tag_list)
      if tag_list.present?
        tag_list.collect { |e| link_to(e, resource_ns1_general_search_path(e)) }.join(" ").html_safe
      end
    end

    def row_links(current_record)
      list = []
      list << link_to("詳細", [:resource_ns1, current_record], "class": "btn btn-link btn-xs")
      list << link_to("コピー".html_safe, "#", "class": "btn btn-link btn-xs kif_clipboard_copy_button", data: {kif_direct_access_path: url_for([:resource_ns1, current_record, format: "kif"])})
      list << link_to("山", [:resource_ns1, current_record, mountain: true], "class": "btn btn-link btn-xs", remote: true, data: {toggle: :tooltip, title: "将棋山脈"})
      # list << link_to(h.image_tag("piyo_shogi_app.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([:resource_ns1, current_record, format: "kif"])))
      list.compact.join(" ").html_safe
    end

    def battle2_user_link(battle2_record, judge_key)
      if battle2_ship = battle2_record.battle2_ships.judge_key_eq(judge_key)
        h.battle2_user_link2(battle2_ship)
      end
    end

    def battle2_state_info_decorate(battle2_record)
      name = battle2_record.battle2_state_info.name
      str = name
      battle2_state_info = battle2_record.battle2_state_info
      if v = battle2_state_info.label_key
        str = tag.span(str, "class": "text-#{v}")
      end
      link_to(str, resource_ns1_general_search_path(name))
    end
  end
end

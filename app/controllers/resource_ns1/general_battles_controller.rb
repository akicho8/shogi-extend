# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局情報テーブル (general_battles as GeneralBattle)
#
# |--------------------------+-----------------+-------------+-------------+------+-------|
# | カラム名                 | 意味            | タイプ      | 属性        | 参照 | INDEX |
# |--------------------------+-----------------+-------------+-------------+------+-------|
# | id                       | ID              | integer(8)  | NOT NULL PK |      |       |
# | battle_key               | 対局キー        | string(255) | NOT NULL    |      | A!    |
# | battled_at               | 対局日          | datetime    |             |      |       |
# | kifu_body                | 棋譜内容        | text(65535) | NOT NULL    |      |       |
# | general_battle_state_key | 結果            | string(255) | NOT NULL    |      | B     |
# | turn_max                 | 手数            | integer(4)  | NOT NULL    |      |       |
# | meta_info                | 棋譜ヘッダー    | text(65535) | NOT NULL    |      |       |
# | mountain_url             | 将棋山脈URL     | string(255) |             |      |       |
# | last_accessd_at          | Last accessd at | datetime    | NOT NULL    |      |       |
# | created_at               | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at               | 更新日時        | datetime    | NOT NULL    |      |       |
# |--------------------------+-----------------+-------------+-------------+------+-------|

module ResourceNs1
  class GeneralBattlesController < ApplicationController
    include ModulableCrud::All
    include SharedMethods

    def index

      if true
        if request.format.zip?
          filename = -> {
            parts = []
            parts << "2chkifu"
            if current_general_user
              parts << current_general_user.name
            end
            parts << Time.current.strftime("%Y%m%d%H%M%S")
            parts.concat(current_tags)
            parts.compact.join("_") + ".zip"
          }

          zip_buffer = Zip::OutputStream.write_buffer do |zos|
            current_scope.limit(params[:limit] || 512).each do |general_battle|
              KifuFormatInfo.each.with_index do |e|
                if converted_info = general_battle.converted_infos.text_format_eq(e.key).take
                  zos.put_next_entry("#{e.key}/#{general_battle.battle_key}.#{e.key}")
                  zos.write converted_info.text_body
                end
              end
            end
          end

          send_data(zip_buffer.string, type: Mime[params[:format]], filename: filename.call, disposition: "attachment")
          return
        end
      end

      self.current_records = current_scope.page(params[:page]).per(params[:per])

      @rows = current_records.collect do |general_battle|
        {}.tap do |row|

          if current_general_user
            l_ship = general_battle.myself(current_general_user)
            r_ship = general_battle.rival(current_general_user)
          else
            if general_battle.general_wstate_info.draw
              l_ship = general_battle.general_memberships.black
              r_ship = general_battle.general_memberships.white
            else
              l_ship = general_battle.general_memberships.judge_key_eq(:win)
              r_ship = general_battle.general_memberships.judge_key_eq(:lose)
            end
          end

          if current_general_user
            row["対象棋士"] = general_battle.win_lose_str(l_ship).html_safe + " " + h.general_user_link2(l_ship)
            row["対戦相手"] = general_battle.win_lose_str(r_ship).html_safe + " " + h.general_user_link2(r_ship)
          else
            if general_battle.general_wstate_info.draw
              row["勝ち"] = icon_tag(:fas, :minus, :class => "icon_hidden") + h.general_user_link2(l_ship)
              row["負け"] = icon_tag(:fas, :minus, :class => "icon_hidden") + h.general_user_link2(r_ship)
            else
              row["勝ち"] = icon_tag(:far, :circle) + h.general_user_link2(l_ship)
              row["負け"] = icon_tag(:fas, :times)    + h.general_user_link2(r_ship)
            end
          end

          row["結果"] = general_wstate_info_decorate(general_battle)
          if false
            row["手合割"] = general_battle.preset_link(h, general_battle.meta_info[:header]["手合割"])
            row["棋戦"] = general_battle.tournament_list.collect { |e| link_to(e.truncate(8), resource_ns1_general_search_path(e)) }.join(" ").html_safe
            row[pc_only("戦型対決")] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
            row[pc_only("囲い対決")] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))

            place_list = general_battle.place_list
            str = "".html_safe
            if place_list.present?
              str += link_to(icon_tag(:fas, :map_marker), h.google_maps_url(place_list.join(" ")), target: "_blank")
              str += place_list.collect { |e| link_to(e, resource_ns1_general_search_path(e)) }.join(" ").html_safe
            end
            row["場所"] = str
          end

          turn_max = general_battle.turn_max
          row["手数"] = link_to(turn_max, resource_ns1_general_search_path("手数>=#{(turn_max - 5).clamp(0, Float::INFINITY)} 手数<=#{turn_max + 5}"))

          row["日時"] = general_battle.date_link(h, general_battle.meta_info[:header]["開始日時"])
          row[""] = row_links(general_battle)
        end
      end
    end

    def current_tags
      @current_tags ||= -> {
        s = params[:query].to_s.gsub(/[,\p{blank}]/, " ").strip
        s = s.split
        s.uniq
      }.call
    end

    def current_plus_tags
      @current_plus_tags ||= current_tags.find_all do |e|
        !e.start_with?("-") && !e.match?(/[<>]/)
      end
    end

    def current_minus_tags
      @current_minus_tags ||= current_tags.collect { |e|
        if e.start_with?("-")
          e.remove(/^-/)
        end
      }.compact
    end

    def current_turn_max
      @current_turn_max ||= current_tags.collect { |e|
        if md = e.match(/手数(?<op>[<>]=?)(?<number>\d+)/)
          md.named_captures.symbolize_keys
        end
      }.compact
    end

    def current_form_search_value
      current_tags.join(" ")
    end

    def current_tactics
      @current_tactics ||= current_tags.find_all { |tag| Warabi::TacticInfo.any? { |e| e.model[tag] } }
    end

    def current_general_user
      @current_general_user ||= nil.yield_self { |v|
        current_tags.each do |e|
          if v = GeneralUser.find_by(name: e)
            break v
          end
        end
        v
      }
    end

    private

    def access_log_create
      current_record.update!(last_accessd_at: Time.current)
    end

    def current_scope
      super.yield_self do |s|
        if v = current_plus_tags.presence
          s = s.tagged_with(v)
        end

        if v = current_minus_tags.presence
          s = s.tagged_with(v, exclude: true)
        end

        if v = current_turn_max.presence
          v.each do |v|
            s = s.where("turn_max #{v[:op]} #{v[:number]}")
          end
        end

        s.order(battled_at: :desc)
      end
    end

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
      list << link_to("コピー".html_safe, "#", "class": "button is-small kif_clipboard_copy_button", data: {kif_direct_access_path: url_for([:resource_ns1, current_record, format: "kif"])})
      list << link_to("詳細", [:resource_ns1, current_record], "class": "button is-small")
      # list << link_to("山", [:resource_ns1, current_record, mountain: true], "class": "button is-small", remote: true, data: {toggle: :tooltip, title: "将棋山脈"})
      # list << link_to(h.image_tag("piyo_shogi_app.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([:resource_ns1, current_record, format: "kif"])))
      list.compact.join(" ").html_safe
    end

    def general_user_link(general_battle, judge_key)
      if general_membership = general_battle.general_memberships.judge_key_eq(judge_key)
        h.general_user_link2(general_membership)
      end
    end

    def general_wstate_info_decorate(general_battle)
      name = general_battle.general_wstate_info.name
      str = name
      general_wstate_info = general_battle.general_wstate_info
      if v = general_wstate_info.label_key
        str = tag.span(str, "class": "text-#{v}")
      end
      link_to(str, resource_ns1_general_search_path(name))
    end
  end
end

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battleテーブル (general_battles as General::Battle)
#
# |------------------+------------------+-------------+-------------+------+-------|
# | カラム名         | 意味             | タイプ      | 属性        | 参照 | INDEX |
# |------------------+------------------+-------------+-------------+------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |      |       |
# | key       | Battle key       | string(255) | NOT NULL    |      | A!    |
# | battled_at       | Battled at       | datetime    |             |      |       |
# | kifu_body        | Kifu body        | text(65535) | NOT NULL    |      |       |
# | battle_state_key | Battle state key | string(255) | NOT NULL    |      | B     |
# | turn_max         | Turn max         | integer(4)  | NOT NULL    |      |       |
# | meta_info        | Meta info        | text(65535) | NOT NULL    |      |       |
# | last_accessd_at  | Last accessd at  | datetime    | NOT NULL    |      |       |
# | created_at       | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |      |       |
# |------------------+------------------+-------------+-------------+------+-------|

module General
  class BattlesController < ApplicationController
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
            current_scope.limit(params[:limit] || 512).each do |battle|
              KifuFormatInfo.each.with_index do |e|
                if kd = battle.to_xxx(e.key)
                  zos.put_next_entry("#{e.key}/#{battle.key}.#{e.key}")
                  zos.write kd
                end
              end
            end
          end

          send_data(zip_buffer.string, type: Mime[params[:format]], filename: filename.call, disposition: "attachment")
          return
        end
      end

      self.current_records = current_scope.page(params[:page]).per(params[:per])

      @rows = current_records.collect do |battle|
        {}.tap do |row|
          row["ID"] = link_to("##{battle.to_param}", battle)

          if current_general_user
            l_ship = battle.myself(current_general_user)
            r_ship = battle.rival(current_general_user)
          else
            if battle.gstate_info.draw
              l_ship = battle.memberships.black
              r_ship = battle.memberships.white
            else
              l_ship = battle.memberships.judge_key_eq(:win)
              r_ship = battle.memberships.judge_key_eq(:lose)
            end
          end

          if current_general_user
            row["対象棋士"] = battle.win_lose_str(l_ship).html_safe + " " + membership_name(l_ship)
            row["対戦相手"] = battle.win_lose_str(r_ship).html_safe + " " + membership_name(r_ship)
          else
            if battle.gstate_info.draw
              row["勝ち"] = icon_tag(:fas, :minus, :class => "icon_hidden") + membership_name(l_ship)
              row["負け"] = icon_tag(:fas, :minus, :class => "icon_hidden") + membership_name(r_ship)
            else
              row["勝ち"] = icon_tag(:far, :circle) + membership_name(l_ship)
              row["負け"] = icon_tag(:fas, :times)  + membership_name(r_ship)
            end
          end

          row["結果"] = gstate_info_decorate(battle)

          if false
            row["手合割"] = battle.preset_link(h, battle.meta_info[:header]["手合割"])
            row["棋戦"] = battle.tournament_list.collect { |e| link_to(e.truncate(8), general_search_path(e)) }.join(" ").html_safe
            row["戦型対決"] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
            row["囲い対決"] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))

            place_list = battle.place_list
            str = "".html_safe
            if place_list.present?
              str += link_to(icon_tag(:fas, :map_marker), h.google_maps_url(place_list.join(" ")), target: "_blank")
              str += place_list.collect { |e| link_to(e, general_search_path(e)) }.join(" ").html_safe
            end
            row["場所"] = str
          end

          turn_max = battle.turn_max
          row["手数"] = link_to(turn_max, general_search_path("手数>=#{(turn_max - 5).clamp(0, Float::INFINITY)} 手数<=#{turn_max + 5}"))

          row["日時"] = battle.date_link(h, battle.meta_info[:header]["開始日時"])
          row[""] = row_links(battle)
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
          if v = User.find_by(name: e)
            break v
          end
        end
        v
      }
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

    def select_func(model, key)
      hash = model.sort_by(&:name).inject({}) { |a, e| a.merge(skill_option_create(e)) }
      view_context.select_tag(key, view_context.options_for_select(hash), :class => "input", "v-model" => key, name: "", include_blank: true)
    end

    private

    def skill_option_create(e)
      str = e.name
      if v = e.alias_names.presence
        v = v.join("・")
        v = "（#{v}）"
        str = "#{str}#{v}"
      end
      {str => e.name}
    end

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
        current_scope.find_by!(key: v)
      else
        current_scope.new
      end
    end

    def versus_tag(*list)
      list = list.compact
      if list.present?
        vs = tag.span(" vs ", :class => "text-muted")
        list.collect { |e| e || "不明" }.join(vs).html_safe
      end
    end

    def tag_links(tag_list)
      if tag_list.present?
        tag_list.collect { |e| link_to(e, general_search_path(e)) }.join(" ").html_safe
      end
    end

    def row_links(battle)
      list = []
      list << link_to("コピー".html_safe, "#", "class": "button is-small kif_clipboard_copy_button", data: {kif_direct_access_path: url_for([battle, format: "kif"])})
      list << link_to("詳細", [battle], "class": "button is-small")
      # list << link_to("山", [ns_prefix, battle, mountain: true], "class": "button is-small", remote: true, data: {toggle: :tooltip, title: "将棋山脈"})
      # list << link_to(h.image_tag("piyo_shogi_app.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([ns_prefix, battle, format: "kif"])))
      list.compact.join(" ").html_safe
    end

    def general_user_link(battle, judge_key)
      if membership = battle.memberships.judge_key_eq(judge_key)
        membership_name(membership)
      end
    end

    def gstate_info_decorate(battle)
      name = battle.gstate_info.name
      str = name
      gstate_info = battle.gstate_info
      if v = gstate_info.label_key
        str = tag.span(str, "class": "text-#{v}")
      end
      link_to(str, general_search_path(name))
    end
  end
end

# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (general_battles as General::Battle)
#
# |-----------------+-----------------+-------------+-------------+------+-------|
# | name            | desc            | type        | opts        | refs | index |
# |-----------------+-----------------+-------------+-------------+------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |      |       |
# | key             | 対局キー        | string(255) | NOT NULL    |      | A!    |
# | battled_at      | 対局日          | datetime    |             |      | C     |
# | kifu_body       | 棋譜内容        | text(65535) | NOT NULL    |      |       |
# | final_key       | 結果            | string(255) | NOT NULL    |      | B     |
# | turn_max        | 手数            | integer(4)  | NOT NULL    |      | D     |
# | meta_info       | 棋譜ヘッダー    | text(65535) | NOT NULL    |      |       |
# | last_accessd_at | Last accessd at | datetime    | NOT NULL    |      |       |
# | created_at      | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |      |       |
# | start_turn      | 開始手数        | integer(4)  | NOT NULL    |      |       |
# |-----------------+-----------------+-------------+-------------+------+-------|

module General
  class BattlesController < ApplicationController
    include ModulableCrud::All
    include BattleControllerSharedMethods1

    let :current_record do
      if v = params[:id].presence
        current_scope.find_by!(key: v)
      else
        current_scope.new
      end
    end

    let :current_tags do
      s = params[:query].to_s.gsub(/[,\p{blank}]/, " ").strip
      s = s.split
      s.uniq
    end

    let :current_plus_tags do
      current_tags.find_all do |e|
        !e.start_with?("-") && !e.match?(/[<>]/)
      end
    end

    let :current_minus_tags do
      current_tags.collect { |e|
        if e.start_with?("-")
          e.remove(/^-/)
        end
      }.compact
    end

    let :current_turn_max do
      current_tags.collect { |e|
        if md = e.match(/手数(?<op>[<>]=?)(?<number>\d+)/)
          md.named_captures.symbolize_keys
        end
      }.compact
    end

    let :current_query do
      current_tags.join(" ")
    end

    let :current_tactics do
      current_tags.find_all { |e| Bioshogi::TacticInfo.any? { |e| e.model[e] } }
    end

    let :current_general_user do
      if e = current_tags.find { |e| User.find_by(name: e) }
        User.find_by(name: e)
      end
    end

    let :current_scope do
      s = current_model
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

    let :current_records do
      current_scope.page(params[:page]).per(params[:per])
    end

    let :rows do
      current_records.collect do |battle|
        {}.tap do |row|
          row["ID"] = link_to("##{battle.to_param}", battle)

          mode = nil
          if current_general_user
            l_ship = battle.myself(current_general_user)
            r_ship = battle.rival(current_general_user)
            if l_ship && r_ship
              mode = :current_general_user
            end
          end
          unless mode
            if battle.final_info.draw
              l_ship = battle.memberships.black
              r_ship = battle.memberships.white
              mode = :draw
            else
              l_ship = battle.memberships.judge_key_eq(:win)
              r_ship = battle.memberships.judge_key_eq(:lose)
              mode = :win_lose
            end
          end

          case mode
          when :current_general_user
            row["対象棋士"] = battle.icon_html(l_ship).html_safe + " " + membership_name(l_ship)
            row["対戦相手"] = battle.icon_html(r_ship).html_safe + " " + membership_name(r_ship)
          when :draw
            row["勝ち"] = icon_tag(:fas, :minus, :class => "icon_hidden") + membership_name(l_ship)
            row["負け"] = icon_tag(:fas, :minus, :class => "icon_hidden") + membership_name(r_ship)
          else
            row["勝ち"] = icon_tag(:fas, :crown, :class => :icon_o) + membership_name(l_ship)
            row["負け"] = icon_tag(:fas, :times, :class => :icon_x) + membership_name(r_ship)
          end

          row["結果"] = final_info_decorate(battle)

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
          # row["手数"] = link_to(turn_max, general_search_path("手数>=#{(turn_max - 5).clamp(0, Float::INFINITY)} 手数<=#{turn_max + 5}"))
          row["手数"] = turn_max

          row["日時"] = battle.date_link(h, battle.meta_info[:header]["開始日時"])
          row[""] = row_links(battle)
        end
      end
    end

    def index
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
          current_scope.limit(zip_download_limit).each do |battle|
            KifuFormatWithBodInfo.each.with_index do |e|
              if kd = battle.to_cached_kifu(e.key)
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

    def versus_tag(*list)
      list = list.compact
      if list.present?
        vs = tag.span(" vs ")
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
      list << link_to("コピー".html_safe, "#", "class": "button is-small kif_clipboard_copy_button", data: {kifu_copy_params: battle.to_kifu_copy_params(self).to_json})
      list << link_to("詳細", [battle], "class": "button is-small")
      # list << link_to("山", [ns_prefix, battle, mountain: true], "class": "button is-small", remote: true, data: {toggle: :tooltip, title: "将棋山脈"})
      # list << link_to(h.image_tag("piyo_shogi_icon.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([ns_prefix, battle, format: "kif"])))
      list.compact.join(" ").html_safe
    end

    def general_user_link(battle, judge_key)
      if membership = battle.memberships.judge_key_eq(judge_key)
        membership_name(membership)
      end
    end

    def final_info_decorate(battle)
      name = battle.final_info.name
      str = name
      final_info = battle.final_info
      if v = final_info.label_key
        str = tag.span(str, "class": "text-#{v}")
      end
      link_to(str, general_search_path(name))
    end

    rescue_from "ActiveRecord::RecordNotFound" do |exception|
      redirect_to [:general, :battles], alert: "見つかりませんでした"
    end
  end
end

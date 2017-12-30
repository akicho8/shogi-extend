# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (swars_battle_records as SwarsBattleRecord)
#
# |--------------------------+-----------------------+-------------+-------------+-----------------------+-------|
# | カラム名                 | 意味                  | タイプ      | 属性        | 参照                  | INDEX |
# |--------------------------+-----------------------+-------------+-------------+-----------------------+-------|
# | id                       | ID                    | integer(8)  | NOT NULL PK |                       |       |
# | battle_key               | Battle key            | string(255) | NOT NULL    |                       | A!    |
# | battled_at               | Battled at            | datetime    | NOT NULL    |                       |       |
# | battle_rule_key          | Battle rule key       | string(255) | NOT NULL    |                       | B     |
# | csa_seq                  | Csa seq               | text(65535) | NOT NULL    |                       |       |
# | battle_state_key         | Battle state key      | string(255) | NOT NULL    |                       | C     |
# | win_swars_battle_user_id | Win swars battle user | integer(8)  |             | => SwarsBattleUser#id | D     |
# | turn_max                 | 手数                  | integer(4)  | NOT NULL    |                       |       |
# | meta_info                | 棋譜ヘッダー          | text(65535) | NOT NULL    |                       |       |
# | mountain_url             | 将棋山脈URL           | string(255) |             |                       |       |
# | created_at               | 作成日時              | datetime    | NOT NULL    |                       |       |
# | updated_at               | 更新日時              | datetime    | NOT NULL    |                       |       |
# |--------------------------+-----------------------+-------------+-------------+-----------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】SwarsBattleUserモデルで has_many :swars_battle_records されていません
#--------------------------------------------------------------------------------

module ResourceNs1
  class SwarsBattleRecordsController < ApplicationController
    include ModulableCrud::All
    include SharedMethods

    def index
      if current_uid
        before_count = 0
        if swars_battle_user = SwarsBattleUser.find_by(uid: current_uid)
          before_count = swars_battle_user.swars_battle_records.count
        end

        Rails.cache.fetch("basic_import_#{current_uid}", expires_in: Rails.env.production? ? 30.seconds : 0) do
          SwarsBattleRecord.basic_import(uid: current_uid)
          nil
        end

        @swars_battle_user = SwarsBattleUser.find_by(uid: current_uid)
        if @swars_battle_user
          count_diff = @swars_battle_user.swars_battle_records.count - before_count
          if count_diff.zero?
          else
            flash.now[:info] = "#{count_diff}件新しく見つかりました"
          end
          @swars_battle_user.swars_battle_user_receptions.create!
        else
          flash.now[:warning] = "#{current_uid} さんのデータは見つかりませんでした"
        end
      end

      @swars_battle_records = SwarsBattleRecord.all
      @swars_battle_records = @swars_battle_records.joins(:swars_battle_ships => :swars_battle_user)
      @swars_battle_records = @swars_battle_records.includes(:win_swars_battle_user)
      if @swars_battle_user
        @swars_battle_records = @swars_battle_records.where(SwarsBattleUser.arel_table[:id].eq(@swars_battle_user.id))
      end
      if current_tags
        @swars_battle_records = @swars_battle_records.tagged_with(current_tags)
      end

      @swars_battle_records = @swars_battle_records.order(battled_at: :desc)

      if true
        if request.format.zip?
          filename = -> {
            parts = []
            parts << "shogiwars"
            if @swars_battle_user
              parts << @swars_battle_user.uid
            end
            parts << Time.current.strftime("%Y%m%d%H%M%S")
            if current_tags
              parts.concat(current_tags)
            end
            parts.compact.join("_") + ".zip"
          }

          zip_buffer = Zip::OutputStream.write_buffer do |zos|
            @swars_battle_records.limit(params[:limit] || 512).each do |swars_battle_record|
              KifuFormatInfo.each.with_index do |e|
                if converted_info = swars_battle_record.converted_infos.text_format_eq(e.key).take
                  zos.put_next_entry("#{e.key}/#{swars_battle_record.battle_key}.#{e.key}")
                  zos.write converted_info.text_body
                end
              end
            end
          end

          send_data(zip_buffer.string, type: Mime[params[:format]], filename: filename.call, disposition: "attachment")
          return
        end
      end

      @swars_battle_records = @swars_battle_records.page(params[:page]).per(params[:per])

      @rows = @swars_battle_records.collect do |swars_battle_record|
        {}.tap do |row|
          if @swars_battle_user
            l_ship = swars_battle_record.myself(@swars_battle_user)
            r_ship = swars_battle_record.rival(@swars_battle_user)
          else
            if swars_battle_record.win_swars_battle_user
              l_ship = swars_battle_record.swars_battle_ships.judge_key_eq(:win)
              r_ship = swars_battle_record.swars_battle_ships.judge_key_eq(:lose)
            else
              l_ship = swars_battle_record.swars_battle_ships.black
              r_ship = swars_battle_record.swars_battle_ships.white
            end
          end

          if @swars_battle_user
            row["対象プレイヤー"] = swars_battle_record.win_lose_str(l_ship.swars_battle_user).html_safe + " " + link_to(l_ship.name_with_grade, l_ship.swars_battle_user)
            row["対戦相手"]       = swars_battle_record.win_lose_str(r_ship.swars_battle_user).html_safe + " " + link_to(r_ship.name_with_grade, r_ship.swars_battle_user)
          else
            if swars_battle_record.win_swars_battle_user
              row["勝ち"] = Fa.icon_tag(:circle_o) + swars_battle_user_link2(l_ship)
              row["負け"] = Fa.icon_tag(:times)    + swars_battle_user_link2(r_ship)
            else
              row["勝ち"] = Fa.icon_tag(:minus, :class => "icon_hidden") + swars_battle_user_link2(l_ship)
              row["負け"] = Fa.icon_tag(:minus, :class => "icon_hidden") + swars_battle_user_link2(r_ship)
            end
          end
          row["判定"] = swars_battle_state_info_decorate(swars_battle_record)
          if false
            row["戦法"] = swars_battle_record.tag_list.collect { |e| link_to(e, resource_ns1_swars_search_path(e)) }.join(" ").html_safe
          else
            row[pc_only("戦型対決")] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
            row[pc_only("囲い対決")] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))
          end
          row["手数"] = swars_battle_record.turn_max
          row["種類"] = link_to(swars_battle_record.swars_battle_rule_info.name, resource_ns1_swars_search_path(swars_battle_record.swars_battle_rule_info.name))

          key = :battle_long
          if swars_battle_record.battled_at >= Time.current.midnight
            key = :battle_short
          end
          row["日時"] = swars_battle_record.battled_at.to_s(key)

          row[""] = row_links(swars_battle_record)
        end
      end
    end

    def current_query_hash
      if e = [:key, :player, :query, :user].find { |e| params[e].present? }
        acc = {}
        params[e].to_s.gsub(/\p{blank}/, " ").strip.split(/\s+/).each do |s|
          if s.match?(/\A(tag):/i) || query_nihongo?(s)
            acc[:tags] ||= []
            acc[:tags] << s.remove("tag:")
          else
            # https://shogiwars.heroz.jp/users/history/yuuki_130?gtype=&locale=ja -> yuuki_130
            # https://shogiwars.heroz.jp/users/yuuki_130                          -> yuuki_130
            if true
              if url = URI::Parser.new.extract(s).first
                uri = URI(url)
                if md = uri.path.match(%r{/users/history/(.*)|/users/(.*)})
                  s = md.captures.compact.first
                end
                logger.info([url, s].to_t)
              end
            end
            acc[:uid] ||= []
            acc[:uid] << s
          end
        end
        acc
      end
    end

    def current_tags
      if v = current_query_hash
        v[:tags]
      end
    end

    def current_uid
      if v = current_query_hash
        if v = v[:uid]
          v.first
        end
      end
    end

    def query_nihongo?(s)
      s.match?(/[\p{Hiragana}\p{Katakana}\p{Han}]/) # 長音符は無視
    end

    def current_form_search_value
      if current_query_hash
        current_query_hash.values.join(" ")
      end
    end

    rescue_from "Mechanize::ResponseCodeError" do |exception|
      flash.now[:warning] = "該当のユーザーが見つからないか、混み合っています。"
      if Rails.env.development?
        flash.now[:alert] = "#{exception.class.name}: #{exception.message}"
      end
      render :show
    end

    private

    def raw_current_record
      if v = params[:id].presence
        SwarsBattleRecord.single_battle_import(v)
        current_scope.find_by!(battle_key: v)
      else
        current_scope.new
      end
    end

    def pc_only(v)
      tag.span(v, :class => "visible-lg")
    end

    def versus_tag(*list)
      if list.compact.empty?
      else
        vs = tag.span(" vs ", :class => "text-muted")
        str = list.collect { |e| e || "不明" }.join(vs).html_safe
        pc_only(str)
      end
    end

    def tag_links(tag_list)
      if tag_list.blank?
      else
        tag_list.collect { |e| link_to(e, resource_ns1_swars_search_path(e)) }.join(" ").html_safe
      end
    end

    def row_links(current_record)
      list = []
      list << link_to("詳細", [:resource_ns1, current_record], "class": "btn btn-link btn-xs")
      list << link_to("コピー".html_safe, "#", "class": "btn btn-link btn-xs kif_clipboard_copy_button", data: {kif_direct_access_path: url_for([:resource_ns1, current_record, format: "kif"])})
      list << link_to("戦", swars_real_battle_url(current_record), "class": "btn btn-link btn-xs", target: "_blank", data: {toggle: :tooltip, title: "将棋ウォーズ"})
      if Rails.env.development? && false
        list << link_to("山脈(remote:false)", [:resource_ns1, current_record, mountain: true, fallback_location: url_for([:s])], "class": "btn btn-link btn-xs", remote: false)
      end
      list << link_to("山", [:resource_ns1, current_record, mountain: true], "class": "btn btn-link btn-xs", remote: true, data: {toggle: :tooltip, title: "将棋山脈"})
      # list << link_to(h.image_tag("piyo_shogi_app.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([:resource_ns1, current_record, format: "kif"])))
      list.compact.join(" ").html_safe
    end

    def swars_battle_user_link(swars_battle_record, judge_key)
      if swars_battle_ship = swars_battle_record.swars_battle_ships.judge_key_eq(judge_key)
        swars_battle_user_link2(swars_battle_ship)
      end
    end

    def swars_battle_user_link2(swars_battle_ship)
      link_to(swars_battle_ship.name_with_grade, swars_battle_ship.swars_battle_user)
    end

    def swars_battle_state_info_decorate(swars_battle_record)
      str = swars_battle_record.swars_battle_state_info.name
      swars_battle_state_info = swars_battle_record.swars_battle_state_info
      if v = swars_battle_state_info.label_key
        str = tag.span(str, "class": "text-#{v}")
      end
      if v = swars_battle_state_info.icon_key
        str = h.icon_tag(v) + str
      end
      str
    end

  end
end

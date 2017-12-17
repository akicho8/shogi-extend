class SwarsTopsController < ApplicationController
  def show
    if current_uid
      before_count = 0
      if battle_user = BattleUser.find_by(uid: current_uid)
        before_count = battle_user.battle_records.count
      end

      Rails.cache.fetch("import_all_#{current_uid}", expires_in: Rails.env.production? ? 30.seconds : 0) do
        BattleRecord.import_all(uid: current_uid)
        nil
      end

      @battle_user = BattleUser.find_by(uid: current_uid)
      if @battle_user
        count_diff = @battle_user.battle_records.count - before_count
        if count_diff.zero?
        else
          flash.now[:info] = "#{count_diff}件新しく見つかりました"
        end
      else
        flash.now[:warning] = "#{current_uid} さんのデータは見つかりませんでした"
      end
    end

    if @battle_user
      @battle_records = @battle_user.battle_records
    else
      @battle_records = BattleRecord.all
    end

    if current_tags
      @battle_records = @battle_records.tagged_with(current_tags)
    end

    @battle_records = @battle_records.order(battled_at: :desc)

    if true
      if request.format.zip?
        filename = -> {
          parts = []
          parts << "shogiwars"
          if @battle_user
            parts << @battle_user.uid
          end
          parts << Time.current.strftime("%Y%m%d%H%M%S")
          if current_tags
            parts.concat(current_tags)
          end
          parts.compact.join("_") + ".zip"
        }

        zip_buffer = Zip::OutputStream.write_buffer do |zos|
          @battle_records.limit(params[:limit] || 512).each do |battle_record|
            KifuFormatInfo.each.with_index do |e|
              if converted_info = battle_record.converted_infos.text_format_eq(e.key).take
                zos.put_next_entry("#{e.key}/#{battle_record.battle_key}.#{e.key}")
                zos.write converted_info.text_body
              end
            end
          end
        end

        send_data(zip_buffer.string, type: Mime[params[:format]], filename: filename.call, disposition: "attachment")
        return
      end
    end

    @battle_records = @battle_records.page(params[:page]).per(params[:per])

    @rows = @battle_records.collect do |battle_record|
      {}.tap do |row|
        if @battle_user
          current_user_ship = battle_record.current_user_ship(@battle_user)
          reverse_user_ship = battle_record.reverse_user_ship(@battle_user)
          row["対象プレイヤー"] = battle_record.win_lose_str(current_user_ship.battle_user).html_safe + " " + link_to(current_user_ship.name_with_rank, current_user_ship.battle_user)
          row["対戦相手"]       = battle_record.win_lose_str(reverse_user_ship.battle_user).html_safe + " " + link_to(reverse_user_ship.name_with_rank, reverse_user_ship.battle_user)
        else
          if battle_record.win_battle_user
            row["勝ち"] = Fa.icon_tag(:circle_o) + battle_user_link(battle_record, :win)
            row["負け"] = Fa.icon_tag(:times) + battle_user_link(battle_record, :lose)
          else
            row["勝ち"] = Fa.icon_tag(:minus, :class => "icon_hidden") + battle_user_link2(battle_record.battle_ships.black)
            row["負け"] = Fa.icon_tag(:minus, :class => "icon_hidden") + battle_user_link2(battle_record.battle_ships.white)
          end
        end
        row["判定"] = battle_state_info_decorate(battle_record)
        if false
          row["戦法"] = battle_record.tag_list.collect { |e| link_to(e, query_search_path(e)) }.join(" ").html_safe
        else

          if @battle_user
            l_ship = battle_record.current_user_ship(@battle_user)
            r_ship = battle_record.reverse_user_ship(@battle_user)
          else
            l_ship = battle_record.battle_ships.black
            r_ship = battle_record.battle_ships.white
          end

          row[pc_only("戦型対決")] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
          row[pc_only("囲い対決")] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))
        end
        row["手数"] = battle_record.turn_max
        row["種類"] = battle_record.battle_rule_info.name

        key = :battle_long
        if battle_record.battled_at >= Time.current.midnight
          key = :battle_short
        end
        row["日時"] = battle_record.battled_at.to_s(key)

        row[""] = row_links(battle_record)
      end
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
      tag_list.collect { |e| link_to(e, query_search_path(e)) }.join(" ").html_safe
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

  def battle_user_link(battle_record, judge_key)
    if battle_ship = battle_record.battle_ships.judge_key_eq(judge_key).take
      battle_user_link2(battle_ship)
    end
  end

  def battle_user_link2(battle_ship)
    link_to(battle_ship.name_with_rank, battle_ship.battle_user)
  end

  def battle_state_info_decorate(battle_record)
    str = battle_record.battle_state_info.name
    battle_state_info = battle_record.battle_state_info
    if v = battle_state_info.label_key
      str = tag.span(str, "class": "text-#{v}")
    end
    if v = battle_state_info.icon_key
      str = h.icon_tag(v) + str
    end
    str
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
    notify_airbrake(exception)
    flash.now[:warning] = "該当のユーザーが見つからないか、混み合っています。"
    if Rails.env.development?
      flash.now[:alert] = "#{exception.class.name}: #{exception.message}"
    end
    render :show
  end
end

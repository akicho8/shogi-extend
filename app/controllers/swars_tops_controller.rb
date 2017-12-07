class SwarsTopsController < ApplicationController
  def show
    if current_uid
      before_count = 0
      if battle_user = BattleUser.find_by(uid: current_uid)
        before_count = battle_user.battle_records.count
      end

      Rails.cache.fetch("import_all_#{current_uid}", expires_in: Rails.env.production? ? 30.seconds : 5.seconds) do
        BattleRecord.import_all(uid: current_uid)
        Time.current
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

    @battle_records = @battle_records.order(battled_at: :desc).page(params[:page]).per(params[:per])

    @rows = @battle_records.collect do |battle_record|
      {}.tap do |row|
        if @battle_user
          current_user_ship = battle_record.current_user_ship(@battle_user)
          reverse_user_ship = battle_record.reverse_user_ship(@battle_user)
          row["対象プレイヤー"] = battle_record.win_lose_str(current_user_ship.battle_user).html_safe + " " + h.link_to(current_user_ship.name_with_rank, current_user_ship.battle_user)
          row["対戦相手"]       = battle_record.win_lose_str(reverse_user_ship.battle_user).html_safe + " " + h.link_to(reverse_user_ship.name_with_rank, reverse_user_ship.battle_user)
        else
          if battle_record.win_battle_user
            row["勝ち"] = Fa.fa_i(:circle_o) + battle_user_link(battle_record, :win)
            row["負け"] = Fa.fa_i(:circle) + battle_user_link(battle_record, :lose)
          else
            row["勝ち"] = Fa.fa_i(:minus, :class => "icon_hidden") + battle_user_link2(battle_record.battle_ships.black)
            row["負け"] = Fa.fa_i(:minus, :class => "icon_hidden") + battle_user_link2(battle_record.battle_ships.white)
          end
        end
        row["判定"] = battle_state_info_decorate(battle_record)
        if false
          row["囲い・戦型"] = battle_record.tag_list.collect { |e| h.link_to(e, query_search_path(e)) }.join(" ").html_safe
        else
          vs = h.tag.span(" vs ", :class => "text-muted")

          if @battle_user
            l_ship = battle_record.current_user_ship(@battle_user)
            r_ship = battle_record.reverse_user_ship(@battle_user)
          else
            l_ship = battle_record.battle_ships.black
            r_ship = battle_record.battle_ships.white
          end

          row[pc_only("戦型対決")] = pc_only([tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list)].join(vs).html_safe)
          row[pc_only("囲い対決")] = pc_only([tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list)].join(vs).html_safe)
        end
        row["手数"] = battle_record.turn_max
        row["種類"] = battle_record.battle_rule_info.name
        row["日時"] = battle_record.battled_at.to_s(:battle_ymd)
        row[""] = row_links(battle_record)
      end
    end
  end

  def pc_only(v)
    h.tag.span(v, :class => "visible-lg")
  end

  def tag_links(tag_list)
    if tag_list.blank?
      "不明"
    else
      tag_list.collect { |e| h.link_to(e, query_search_path(e)) }.join(" ").html_safe
    end
  end

  def row_links(current_record)
    list = []
    list << h.link_to("詳細", [:resource_ns1, current_record], "class": "btn btn-default btn-sm")
    if Rails.env.development?
      list << h.link_to("山脈(remote:false)", [:resource_ns1, current_record, mountain: true, fallback_location: url_for([:s])], "class": "btn btn-default btn-sm", remote: false)
    end
    list << h.link_to("山脈", [:resource_ns1, current_record, mountain: true], "class": "btn btn-default btn-sm", remote: true)
    list << h.link_to("コピー".html_safe, "#", "class": "btn btn-primary btn-sm kif_clipboard_copy_button", data: {kif_direct_access_path: url_for([:resource_ns1, current_record, format: "kif"])})
    list << h.link_to("戦", swars_board_url(current_record), "class": "btn btn-default btn-sm")
    list << h.link_to(h.image_tag("piyo_link.png", "class": "row_piyo_link"), piyo_link_url(full_url_for([:resource_ns1, current_record, format: "kif"])))
    list.compact.join(" ").html_safe
  end

  def battle_user_link(battle_record, win_lose_key)
    if battle_ship = battle_record.battle_ships.win_lose_key_eq(win_lose_key).take
      battle_user_link2(battle_ship)
    end
  end

  def battle_user_link2(battle_ship)
    h.link_to(battle_ship.name_with_rank, battle_ship.battle_user)
  end

  def battle_state_info_decorate(battle_record)
    str = battle_record.battle_state_info.name
    battle_state_info = battle_record.battle_state_info
    if v = battle_state_info.label_key
      str = h.tag.span(str, "class": "label label-#{v}")
    end
    if v = battle_state_info.icon_key
      str = h.fa_i(v) + str
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
          # https://shogiwars.heroz.jp/users/history/xxx?gtype=&locale=ja -> xxx
          if true
            if url = URI::Parser.new.extract(s).first
              if md = URI(url).path.match(%r{history/(.*)})
                s = md.captures.first
              end
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

  def h
    @h ||= view_context
  end

  rescue_from "Mechanize::ResponseCodeError" do |exception|
    notify_airbrake(exception)
    flash.now[:warning] = "該当のユーザーが見つかりません"
    if Rails.env.development?
      flash.now[:alert] = "#{exception.class.name}: #{exception.message}"
    end
    render :show
  end
end

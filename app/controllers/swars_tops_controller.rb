class SwarsTopsController < ApplicationController
  def show
    if Rails.env.development?
      # BattleUser.destroy_all
      # BattleRecord.destroy_all
    end

    if current_battle_user_key
      before_count = 0
      if battle_user = BattleUser.find_by(battle_user_key: current_battle_user_key)
        before_count = battle_user.battle_records.count
      end

      Rails.cache.fetch("import_all_#{current_battle_user_key}", expires_in: Rails.env.production? ? 30.seconds : 5.seconds) do
        BattleRecord.import_all(battle_user_key: current_battle_user_key)
        Time.current
      end

      @battle_user = BattleUser.find_by(battle_user_key: current_battle_user_key)
      if @battle_user
        count_diff = @battle_user.battle_records.count - before_count
        if count_diff.zero?
        else
          flash.now[:info] = "#{count_diff}件新しく見つかりました"
        end
      else
        flash.now[:warning] = "#{current_battle_user_key} さんのデータは見つかりませんでした"
      end
    end

    if @battle_user
      @battle_records = @battle_user.battle_records
    else
      @battle_records = BattleRecord.all
    end
    @battle_records = @battle_records.order(battled_at: :desc).page(params[:page])

    @rows = @battle_records.collect do |battle_record|
      {}.tap do |row|
        if @battle_user
          current_user_ship = battle_record.current_user_ship(@battle_user)
          reverse_user_ship = battle_record.reverse_user_ship(@battle_user)
          row["対象プレイヤー"] = battle_record.kekka_emoji(current_user_ship.battle_user).html_safe + " " + h.link_to(current_user_ship.name_with_rank, current_user_ship.battle_user)
          row["対戦相手"]       = battle_record.kekka_emoji(reverse_user_ship.battle_user).html_safe + " " + h.link_to(reverse_user_ship.name_with_rank, reverse_user_ship.battle_user)
          # if !Rails.env.production? || params[:debug].present?
          #   row["棋神"] = battle_record.kishin_tsukatta?(reverse_user_ship) ? "降臨" : ""
          # end
          # row["段級"] = reverse_user_ship.battle_rank.name
        else
          # row["勝ち"] = "○".html_safe + " " + battle_user_link(battle_record, true)
          # row["負け"] = "●".html_safe + " " + battle_user_link(battle_record, false)
          row["勝ち"] = "<i class='fa fa-circle-o'></i>".html_safe + " " + battle_user_link(battle_record, true)
          row["負け"] = "<i class='fa fa-circle'></i>".html_safe + " " + battle_user_link(battle_record, false)
        end
        row["判定"] = battle_result_info_decorate(battle_record)
        row["手数"] = battle_record.turn_max
        row["種類"] = battle_record.battle_group_info.name
        row["日時"] = battled_at_decorate(battle_record)
        row[""] = row_links(battle_record)
      end
    end
  end

  def row_links(battle_record)
    list = []
    list << h.link_to("詳細", [:name_space1, battle_record], "class": "btn btn-default btn-sm")
    if Rails.env.development?
      list << h.link_to("山脈(remote:false)", [:name_space1, battle_record, sanmyaku: true, fallback_location: url_for([:s])], "class": "btn btn-default btn-sm", remote: false)
    end
    list << h.link_to("山脈", [:name_space1, battle_record, sanmyaku: true], "class": "btn btn-default btn-sm", remote: true)
    list << h.link_to("コピー".html_safe, "#", "class": "btn btn-primary btn-sm kif_clipboard_copy_button", data: {kif_direct_access_path: url_for([:name_space1, battle_record, format: "kif"])})

    # list << h.link_to("KIF", [:name_space1, battle_record, format: "kif"], "class": "btn btn-default btn-sm")
    # list << h.link_to("KI2", [:name_space1, battle_record, format: "ki2"], "class": "btn btn-default btn-sm")
    # list << h.link_to("CSA", [:name_space1, battle_record, format: "csa"], "class": "btn btn-default btn-sm")

    # list << h.link_to("ウォ", swars_board_url(battle_record), "class": "btn btn-default btn-sm")

    list.compact.join(" ").html_safe
  end

  def battle_user_link(battle_record, win_flag)
    battle_ship = battle_record.battle_ships.win_flag_eq(win_flag).take!
    s = h.link_to(battle_ship.name_with_rank, battle_ship.battle_user)
    # if !Rails.env.production? || params[:debug].present?
    #   if battle_record.kishin_tsukatta?(battle_ship)
    #     s += "&#x2757;".html_safe
    #   end
    # end
    s
  end

  def battled_at_decorate(battle_record)
    # if battle_record.battled_at < 1.months.ago
    #   h.time_ago_in_words(battle_record.battled_at) + "前"
    # else
    # end
    battle_record.battled_at.to_s(:battle_ymd)
  end

  def battle_result_info_decorate(battle_record)
    if v = battle_record.battle_result_info.label_key
      h.tag.span(battle_record.battle_result_info.name, "class": "label label-#{v}")
    else
      battle_record.battle_result_info.name
    end
  end

  def current_battle_user_key
    # if Rails.env.development?
    #   params[:battle_user_key] = "hanairobiyori"
    # end

    if e = [:battle_user_key, :key, :player, :user].find { |e| params[e].present? }
      s = params[e].to_s.gsub(/\p{blank}/, " ").strip

      # https://shogiwars.heroz.jp/users/history/xxx?gtype=&locale=ja -> xxx
      if true
        if url = URI::Parser.new.extract(s).first
          if md = URI(url).path.match(%r{history/(.*)})
            s = md.captures.first
          end
        end
      end

      s.presence
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

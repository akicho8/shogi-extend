class SwarsTopsController < ApplicationController
  def show
    if Rails.env.development?
      # WarUser.destroy_all
      # WarRecord.destroy_all
    end

    if current_user_key
      before_count = 0
      if war_user = WarUser.find_by(user_key: current_user_key)
        before_count = war_user.war_records.count
      end

      Rails.cache.fetch("import_all_#{current_user_key}", expires_in: Rails.env.production? ? 30.seconds : 5.seconds) do
        WarRecord.import_all(user_key: current_user_key)
        Time.current
      end

      @war_user = WarUser.find_by(user_key: current_user_key)
      if @war_user
        count_diff = @war_user.war_records.count - before_count
        if count_diff.zero?
        else
          flash.now[:info] = "#{count_diff}件新しく見つかりました"
        end
      else
        flash.now[:warning] = "#{current_user_key} さんのデータは見つかりませんでした"
      end
    end

    if @war_user
      @war_records = @war_user.war_records.order(battled_at: :desc).page(params[:page])
    else
      @war_records = WarRecord.order(battled_at: :desc).page(params[:page])
    end

    @rows = @war_records.collect do |war_record|
      row = {}
      if @war_user
        aite_user_ship = war_record.aite_user_ship(@war_user)
        row["結果"] = war_record.kekka_emoji(@war_user).html_safe
        row["対戦相手"] = h.link_to(aite_user_ship.war_user.user_key, aite_user_ship.war_user)
        if !Rails.env.production? || params[:debug].present?
          row["棋神"] = war_record.kishin_tsukatta?(aite_user_ship) ? "降臨" : ""
        end
        row["段級"] = aite_user_ship.war_rank.name
      else
        row["勝者"] = user_link(war_record, true)
        row["敗者"] = user_link(war_record, false)
      end
      row["判定"] = war_record_reason_info_name(war_record)
      row["手数"] = war_record.turn_max
      row["種類"] = war_record.game_type_info.name
      row["日時"] = nichiji(war_record)
      row[""] = row_saigonotokoro_build(war_record)
      row
    end
  end

  def row_saigonotokoro_build(war_record)
    list = []
    list << h.link_to("詳細", [:name_space1, war_record], :class => "btn btn-default btn-sm")
    list << h.link_to("KIF", [:name_space1, war_record, format: "kif"], :class => "btn btn-default btn-sm")
    list << h.link_to("KI2", [:name_space1, war_record, format: "ki2"], :class => "btn btn-default btn-sm")
    list << h.link_to("CSA", [:name_space1, war_record, format: "csa"], :class => "btn btn-default btn-sm")
    list << h.link_to("ウォ", swars_board_url(war_record), :class => "btn btn-default btn-sm")
    list << h.link_to("コピー", "#", :class => "btn btn-default btn-sm kif_clipboard_copy_button", data: {kif_direct_access_path: url_for([:name_space1, war_record, format: "kif"])})
    list.compact.join(" ").html_safe
  end

  def user_link(war_record, win_flag)
    war_ship = war_record.war_ships.win_flag_is(win_flag).first
    s = h.link_to(war_ship.name_with_rank, war_ship.war_user)
    if !Rails.env.production? || params[:debug].present?
      if war_record.kishin_tsukatta?(war_ship)
        s << "&#x2757;".html_safe
      end
    end
    s
  end

  def nichiji(war_record)
    if war_record.battled_at < 1.months.ago
      h.time_ago_in_words(war_record.battled_at) + "前"
    else
      war_record.battled_at.to_s(:swars_ymd)
    end
  end

  def war_record_reason_info_name(war_record)
    if v = war_record.reason_info.label_key
      h.tag.span(war_record.reason_info.name, :class => "label label-#{v}")
    else
      war_record.reason_info.name
    end
  end

  # def user_link(war_record, win_flag)
  #   war_ship = war_record.war_ships.win_flag_is(win_flag).first
  #   s = h.link_to(war_record.war_ships.send(location).name_with_rank, war_record.war_users.send(location))
  #   if war_record.war_ships.send(location).win_flag?
  #     s += "&#128522;".html_safe
  #   end
  #   s
  # end

  def current_user_key
    if Rails.env.development?
      # params[:user_key] = "hanairobiyori"
    end
    params[:user_key].to_s.gsub(/\p{blank}/, " ").strip.presence
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

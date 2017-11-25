class SwarsTopsController < ApplicationController
  def show
    # WarsUser.destroy_all
    # WarsRecord.destroy_all
    # WarsRecord.destroy_all

    if current_user_key
      before_count = 0
      if wars_user = WarsUser.find_by(user_key: current_user_key)
        before_count = wars_user.wars_records.count
      end

      WarsRecord.import_all(user_key: current_user_key)

      @wars_user = WarsUser.find_by(user_key: current_user_key)
      if @wars_user
        count_diff = @wars_user.wars_records.count - before_count
        if count_diff.zero?
        else
          flash.now[:info] = "#{count_diff}件新しく取り込みました"
        end
      else
        flash.now[:warning] = "#{current_user_key} さんのデータは見つかりませんでした"
      end
    end

    if @wars_user
      @wars_records = @wars_user.wars_records.order(battled_at: :desc).page(params[:page])
      @rows = @wars_records.collect do |wars_record|
        aite_user_ship = wars_record.aite_user_ship(@wars_user)
        {
          "結果" => wars_record.kekka_emoji(@wars_user).html_safe,
          "対戦相手" => h.link_to(aite_user_ship.wars_user.user_key, aite_user_ship.wars_user),
          "段級" => aite_user_ship.wars_rank.name,
          "理由" => wars_record.reason_info&.name || wars_record.reason_key,
          "手数" => wars_record.turn_max,
          "種類" => wars_record.game_type_info.name,
          "日時" => nichiji(wars_record),
          "" => [
            h.link_to("詳細", [:name_space1, wars_record]),
            h.link_to("KIF", [:name_space1, wars_record, format: "kif"]),
            h.link_to("盤上", swars_board_url(wars_record)),
          ].compact.join(" ").html_safe,
        }
      end
    else
      @wars_records = WarsRecord.order(battled_at: :desc).page(params[:page])
      @rows = @wars_records.collect do |wars_record|
        {
          "勝者" => user_link(wars_record, true),
          "敗者" => user_link(wars_record, false),
          "手数" => wars_record.turn_max,
          "種類" => wars_record.game_type_info.name,
          "日時" => nichiji(wars_record),
          "" => [
            h.link_to("詳細", [:name_space1, wars_record]),
          ].compact.join(" ").html_safe,
        }
      end
    end
  end

  def user_link(wars_record, win_flag)
    wars_ship = wars_record.wars_ships.win_flag_is(win_flag).first
    s = h.link_to(wars_ship.name_with_rank, wars_ship.wars_user)
    s
  end

  def nichiji(wars_record)
    if wars_record.battled_at < 1.months.ago
      h.time_ago_in_words(wars_record.battled_at) + "前"
    else
      wars_record.battled_at.to_s(:swars_ymd)
    end
  end
  
  
  # def user_link(wars_record, win_flag)
  #   wars_ship = wars_record.wars_ships.win_flag_is(win_flag).first
  #   s = h.link_to(wars_record.wars_ships.send(location).name_with_rank, wars_record.wars_users.send(location))
  #   if wars_record.wars_ships.send(location).win_flag?
  #     s += "&#128522;".html_safe
  #   end
  #   s
  # end

  def h
    @h ||= view_context
  end

  def current_user_key
    if Rails.env.development?
      # params[:user_key] = "hanairobiyori"
    end
    params[:user_key].to_s.gsub(/\p{blank}/, " ").strip.presence
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

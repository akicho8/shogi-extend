# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as BattleRecord)
#
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味             | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | id                 | ID               | integer(8)  | NOT NULL PK |                  |       |
# | battle_key         | Battle key       | string(255) | NOT NULL    |                  | A!    |
# | battled_at         | Battled at       | datetime    | NOT NULL    |                  |       |
# | battle_rule_key    | Battle rule key  | string(255) | NOT NULL    |                  | B     |
# | csa_seq            | Csa seq          | text(65535) | NOT NULL    |                  |       |
# | battle_state_key   | Battle state key | string(255) | NOT NULL    |                  | C     |
# | win_battle_user_id | Win battle user  | integer(8)  |             | => BattleUser#id | D     |
# | turn_max           | 手数             | integer(4)  | NOT NULL    |                  |       |
# | meta_info          | 棋譜ヘッダー     | text(65535) | NOT NULL    |                  |       |
# | mountain_url       | 将棋山脈URL      | string(255) |             |                  |       |
# | created_at         | 作成日時         | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時         | datetime    | NOT NULL    |                  |       |
# |--------------------+------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

module ResourceNs1
  class BattleRecordsController < ApplicationController
    include ModulableCrud::All

    def index
      if current_uid
        before_count = 0
        if battle_user = BattleUser.find_by(uid: current_uid)
          before_count = battle_user.battle_records.count
        end

        Rails.cache.fetch("basic_import_#{current_uid}", expires_in: Rails.env.production? ? 30.seconds : 0) do
          BattleRecord.basic_import(uid: current_uid)
          nil
        end

        @battle_user = BattleUser.find_by(uid: current_uid)
        if @battle_user
          count_diff = @battle_user.battle_records.count - before_count
          if count_diff.zero?
          else
            flash.now[:info] = "#{count_diff}件新しく見つかりました"
          end
          @battle_user.battle_user_receptions.create!
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
            l_ship = battle_record.myself(@battle_user)
            r_ship = battle_record.rival(@battle_user)
          else
            if battle_record.win_battle_user
              l_ship = battle_record.battle_ships.judge_key_eq(:win)
              r_ship = battle_record.battle_ships.judge_key_eq(:lose)
            else
              l_ship = battle_record.battle_ships.black
              r_ship = battle_record.battle_ships.white
            end
          end

          if @battle_user
            row["対象プレイヤー"] = battle_record.win_lose_str(l_ship.battle_user).html_safe + " " + link_to(l_ship.name_with_grade, l_ship.battle_user)
            row["対戦相手"]       = battle_record.win_lose_str(r_ship.battle_user).html_safe + " " + link_to(r_ship.name_with_grade, r_ship.battle_user)
          else
            if battle_record.win_battle_user
              row["勝ち"] = Fa.icon_tag(:circle_o) + battle_user_link2(l_ship)
              row["負け"] = Fa.icon_tag(:times)    + battle_user_link2(r_ship)
            else
              row["勝ち"] = Fa.icon_tag(:minus, :class => "icon_hidden") + battle_user_link2(l_ship)
              row["負け"] = Fa.icon_tag(:minus, :class => "icon_hidden") + battle_user_link2(r_ship)
            end
          end
          row["判定"] = battle_state_info_decorate(battle_record)
          if false
            row["戦法"] = battle_record.tag_list.collect { |e| link_to(e, resource_ns1_swars_search_path(e)) }.join(" ").html_safe
          else
            row[pc_only("戦型対決")] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
            row[pc_only("囲い対決")] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))
          end
          row["手数"] = battle_record.turn_max
          row["種類"] = link_to(battle_record.battle_rule_info.name, resource_ns1_swars_search_path(battle_record.battle_rule_info.name))

          key = :battle_long
          if battle_record.battled_at >= Time.current.midnight
            key = :battle_short
          end
          row["日時"] = battle_record.battled_at.to_s(key)

          row[""] = row_links(battle_record)
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
      notify_airbrake(exception)
      flash.now[:warning] = "該当のユーザーが見つからないか、混み合っています。"
      if Rails.env.development?
        flash.now[:alert] = "#{exception.class.name}: #{exception.message}"
      end
      render :show
    end

    private

    def raw_current_record
      if v = params[:id].presence
        BattleRecord.single_battle_import(v)
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

    def battle_user_link(battle_record, judge_key)
      if battle_ship = battle_record.battle_ships.judge_key_eq(judge_key)
        battle_user_link2(battle_ship)
      end
    end

    def battle_user_link2(battle_ship)
      link_to(battle_ship.name_with_grade, battle_ship.battle_user)
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

    concerning :SharedMethods do
      included do
        if Rails.env.production?
          if v = ENV["HTTP_BASIC_AUTHENTICATE"].presence
            http_basic_authenticate_with Hash[[:name, :password].zip(v.split(/:/))].merge(only: [:index, :edit, :update, :destroy])
          end
        end

        rescue_from "Bushido::BushidoError" do |exception|
          h = ApplicationController.helpers
          lines = exception.message.lines
          message = lines.first.strip.html_safe
          if field = lines.drop(1).join.presence
            message += "<br>".html_safe
            message += h.content_tag(:pre, field).html_safe
          end
          unless Rails.env.production?
            if exception.backtrace
              message += h.content_tag(:pre, exception.backtrace.first(8).join("\n").html_safe).html_safe
            end
          end
          behavior_after_rescue(message)
        end
      end

      def show
        if params[:mountain]
          current_record.mountain_post_once

          # 通常リンク(remote: false)の場合
          if true
            if request.format.html?
              if current_record.mountain_url
                redirect_to current_record.mountain_url
              else
                # 無限ループしないように fallback_location に mountain を含めないこと
                # redirect_back を使うと referer に mountain に含まれていて無限ループするはずなので注意
                raise MustNotHappen if params[:fallback_location].to_s.include?("mountain")
                redirect_to params[:fallback_location], notice: "混み合っているようです"
              end
              return
            end
          end

          logger.info({mountain_url: current_record.mountain_url}.to_t)
          render "resource_ns1/battle_records/show"
          return
        end

        respond_to do |format|
          format.html
          format.any { kifu_send_data }
        end
      end

      private

      def current_filename
        "#{current_record.battle_key}.#{params[:format]}"
      end

      def kifu_send_data
        text_body = nil
        if converted_info = current_record.converted_infos.find_by(text_format: params[:format])
          text_body = converted_info.text_body
        end

        if access_from_swf_kifu_player?
          response.headers["Content-Type"] = 'text/plain; charset=shift_jis' # 指定しないと utf-8 で返してしまう(が、なくてもよい)
          logger.info response.headers.to_t
          render plain: text_body.tosjis
          return
        end

        if params[:shift_jis].present? || params[:sjis].present?
          text_body = text_body.tosjis
        end

        send_data(text_body, type: Mime[params[:format]], filename: current_filename.encode(current_encode), disposition: false ? "inline" : "attachment")
      end

      # Kifu.swf から呼ばれたときは日付のキーが含まれている
      # Started GET "/r/hanairobiyori-ispt-20171104_220810.kif?20171205090818"
      def access_from_swf_kifu_player?
        params.to_unsafe_h.any? { |k, v| v.blank? && (Date.parse(k) rescue nil) }
      end

      def current_encode
        params[:encode].presence || current_encode_default
      end

      def current_encode_default
        if request.user_agent.to_s.match(/Windows/i)
          "Shift_JIS"
        else
          "UTF-8"
        end
      end

      def behavior_after_rescue(message)
        redirect_to :root, alert: message
      end
    end
  end
end

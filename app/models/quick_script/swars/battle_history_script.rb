module QuickScript
  module Swars
    class BattleHistoryScript < Base
      prepend QueryMod

      self.title = "将棋ウォーズ対局履歴"
      self.description = "指定ユーザーの対局履歴を Google スプレッドシートに出力する (自分であれこれしたい人向け)"
      self.form_method = :post
      self.button_label = "出力"
      self.login_link_show = true
      self.debug_mode = Rails.env.local?

      LIMIT_MAX  = Rails.env.local? ? 10 : 2000
      SEPARATOR  = " / "

      def form_parts
        super + [
          form_part_for_query,
          {
            :label       => "Google スプレッドシートに出力",
            :key         => :google_sheet,
            :type        => debug_mode ? :radio_button : :hidden,
            :dynamic_part => -> {
              {
                :elems       => { "false" => "しない", "true" => "する" },
                :default => params[:google_sheet].to_s.presence || (debug_mode ? "false" : "true"),
              }
            },
          },
          {
            :label       => "バックグラウンド実行する",
            :key         => :bg_request,
            :type        => debug_mode ? :radio_button : :hidden,
            :dynamic_part => -> {
              {
                :elems       => { "false" => "しない", "true" => "する" },
                :default => params[:bg_request].to_s.presence || (debug_mode ? "false" : "true"),
              }
            },
          },
        ]
      end

      def call
        if running_in_foreground
          if request_get?
            return "将棋ウォーズ棋譜検索で保持している履歴の中から直近最大#{LIMIT_MAX}件をGoogleスプレッドシートに出力します。"
          end
          if request_post?
            validate!
            if flash.present?
              return
            end
            if current_bg_request
              call_later
              self.form_method = nil # form をまるごと消す
              return { _autolink: posted_message }
            end
            if current_google_sheet
              redirect_to google_sheet_url, type: :tab_open
              return
            else
              return simple_table(rows, always_table: true)
            end
          end
        end
        if running_in_background
          SystemMailer.notify(subject: long_title, to: current_user.email, bcc: nil, body: google_sheet_url).deliver_later
          AppLog.info(subject: "#{long_title} (to:#{current_user.email})", body: google_sheet_url)
        end
      end

      def rows
        @rows ||= [].tap do |rows|
          s = main_scope
          s = s.joins(:battle)
          s = s.includes(battle: [:memberships, :xmode, :final])
          s = s.includes(taggings: :tag)
          s = s.includes(:user, :op_user, :location, :style, :grade)
          s = s.includes(opponent: { taggings: :tag })
          if false
            s = s.includes(:attack_tags, :defense_tags, :technique_tags, :note_tags)
          end
          s = s.order(battled_at: :desc)
          s = s.limit(LIMIT_MAX)
          s.each do |e|
            Rails.logger.tagged(e.battle.key) do
              rows << record_to_row(e)
            end
          end
        end
      end

      def record_to_row(e)
        {}.tap do |row|
          row["対象"]              = hyper_link(e.user.key, e.user.player_info_url)
          row["対象の段位"]        = e.grade.name
          row["相手"]              = hyper_link(e.op_user.key, e.op_user.player_info_url)
          row["相手の段位"]        = e.opponent.grade.name
          row["勝敗"]              = e.judge.name
          row["結末"]              = e.battle.final.pure_info.name
          row["手数"]              = e.battle.turn_max
          row["開戦"]              = e.battle.critical_turn
          row["中盤"]              = e.battle.outbreak_turn
          row["平均思考"]          = e.think_all_avg
          row["最長考"]            = e.think_max
          row["最終手思考"]        = e.think_last
          row["対象の棋風"]        = e.style.try { pure_info.name }
          row["相手の棋風"]        = e.opponent.style.try { pure_info.name }
          row["持ち時間"]            = e.battle.rule.pure_info.long_name
          row["先後"]              = e.location_human_name
          row["対局モード"]        = e.battle.xmode.name
          row["対局日時"]          = e.battle.battled_at.to_fs(:ymdhms)

          ActiveRecord::Base.logger.tagged("self") do
            row["対象の戦法"]        = e.attack_tag_list.join(SEPARATOR)
            row["対象の囲い"]        = e.defense_tag_list.join(SEPARATOR)
            row["対象の手筋"]        = e.technique_tag_list.join(SEPARATOR)
            row["対象の備考"]        = e.note_tag_list.join(SEPARATOR)
          end

          ActiveRecord::Base.logger.tagged("opponent") do
            row["相手の戦法"]        = e.opponent.attack_tag_list.join(SEPARATOR)
            row["相手の囲い"]        = e.opponent.defense_tag_list.join(SEPARATOR)
            row["相手の手筋"]        = e.opponent.technique_tag_list.join(SEPARATOR)
            row["相手の備考"]        = e.opponent.note_tag_list.join(SEPARATOR)
          end

          row["手合割"]            = e.battle.preset.name
          row["棋力差"]            = e.grade_diff
          row["リンク1"]           = hyper_link("本家",     e.battle.official_url)
          row["リンク2"]           = hyper_link("棋譜",     e.battle.inside_show_url)
          row["リンク3"]           = hyper_link("棋譜検索", e.battle.search_url)
          row["リンク4"]           = hyper_link("ぴよ将棋", e.battle.piyo_shogi_url)
          row["リンク5"]           = hyper_link("KENTO",    e.battle.kento_url)
          row["対象の段位(order)"] = e.grade.priority
          row["相手の段位(order)"] = e.opponent.grade.priority
        end
      end

      ################################################################################

      def current_google_sheet
        params[:google_sheet].to_s == "true"
      end

      def current_bg_request
        params[:bg_request].to_s == "true"
      end

      def long_title
        "#{swars_user.name_with_grade}の#{title}(直近#{rows.size}件)"
      end

      def posted_message
        "承りました。終わったら #{current_user.email} あてに URL を送ります。ずっと残しておきたい場合や編集する場合はそこから自分のところにコピってください。"
      end

      def validate!
        unless current_user
          flash[:notice] = "完了後の通知を受け取るためにログインしよう"
          return
        end
        unless current_user.email_valid?
          flash[:notice] = "ちゃんとしたメールアドレスを登録しよう"
          return
        end
        if swars_user_key.blank?
          flash[:notice] = "ウォーズIDを入力しよう"
          return
        end
        unless swars_user
          flash[:notice] = "#{swars_user_key} さんは存在しません"
          return
        end
        if main_scope.empty?
          flash[:notice] = "対局データがひとつもありません"
          return
        end
      end

      def google_sheet_url
        @google_sheet_url ||= GoogleApi::Facade.new(title: long_title, rows: rows, columns_hash: columns_hash).call
      end

      def columns_hash
        {
          "対局日時"   => { number_format: { type: "DATE",    pattern: "yyyy/MM/dd HH:MM", }, },
          "平均思考"   => { number_format: { type: "NUMBER",  pattern: "0 秒",             }, },
          "最終手思考" => { number_format: { type: "NUMBER",  pattern: "0 秒",             }, },
          "最長考"     => { number_format: { type: "NUMBER",  pattern: "0 秒",             }, },
          "手数"       => { number_format: { type: "NUMBER",  pattern: "0 手",             }, },
          "開戦"       => { number_format: { type: "NUMBER",  pattern: "0 手目",           }, },
          "中盤"       => { number_format: { type: "NUMBER",  pattern: "0 手目",           }, },
        }
      end

      ################################################################################

      def main_scope
        @main_scope ||= swars_user.memberships.where(battle_id: query_scope.ids)
      end

      ################################################################################
    end
  end
end

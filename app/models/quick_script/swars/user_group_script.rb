module QuickScript
  module Swars
    class UserGroupScript < Base
      self.title           = "将棋ウォーズプレイヤー情報一覧"
      self.description     = "指定ユーザーたちの情報を簡単にまとめて表示する (小規模グループ内メンバーの棋力をまとめて把握したいとき用)"
      self.form_method     = :post
      self.button_label    = "実行"
      self.login_link_show = true
      self.debug_mode      = Rails.env.local?

      STAT_OPTIONS            = { sample_max: 500 }
      LIMIT_MAX               = 1000
      USER_ITEMS_TEXT_DEFAULT = <<~EOS
藤森哲也 BOUYATETSU5
伊藤真吾 itoshinTV
戸辺誠 TOBE_CHAN
EOS

      def form_parts
        super + [
          {
            :label           => "名前とウォーズIDたち",
            :key             => :user_items_text,
            :type            => :text,
            :session_sync    => true, # 50人以上貼られるとクッキーセッションに収まらずエラーになるため普通のセッションに保存してはいけない → ここだけでなくすべてセッションに保存してはいけない
            :dynamic_part => -> {
              {
                :default      => params[:user_items_text].to_s.presence,
                :placeholder  => USER_ITEMS_TEXT_DEFAULT,
                :help_message => "名前とウォーズIDのペアを一行ずつ並べてください",
              }
            },
          },
          {
            :label           => "順番",
            :key             => :order_by,
            :type            => :radio_button,
            :session_sync    => true,
            :dynamic_part => -> {
              {
                :elems   => { "grade" => "最高段位", "gentleman" => "行動規範", "vitality" => "勢い", "original" => "そのまま" },
                :default => params[:order_by].presence || "grade",
                :help_message => "上で記入した通りの並びでいいなら「そのまま」にしてください",
              }
            },
          },
          {
            :label => "Google スプレッドシートに出力",
            :key   => :google_sheet,
            :type  => debug_mode ? :radio_button : :hidden,
            :dynamic_part => -> {
              {
                :elems        => { "false" => "しない", "true" => "する" },
                :default      => params[:bg_request].to_s.presence || (debug_mode ? "false" : "true"),
              }
            },
          },
          {
            :label       => "バックグラウンド実行する",
            :key         => :bg_request,
            :type        => debug_mode ? :radio_button : :hidden,
            :dynamic_part => -> {
              {
                :elems   => { "false" => "しない", "true" => "する" },
                :default => params[:bg_request].to_s.presence || (debug_mode ? "false" : "true"),
              }
            },
          },
        ]
      end

      def call
        if running_in_foreground
          if request_get?
            return "指定プレイヤーたちの情報を簡単にまとめてGoogleスプレッドシートに出力します"
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
              redirect_to sheet_url, type: :tab_open
              return { _v_html: sheet_result_html }
            else
              return simple_table(rows, always_table: true)
            end
          end
        end
        if running_in_background
          mail_notify
        end
      end

      # 戻値は Array 型になっている場合もある
      def ordered_scope
        @ordered_scope ||= yield_self do
          s = main_scope
          case current_order_by
          when "grade"
            s = s.joins(:grade).order(::Swars::Grade.arel_table[:priority].asc)
          when "original"
            s = s.order([Arel.sql("FIELD(#{::Swars::User.table_name}.user_key, ?)"), current_user_keys])
          when "gentleman"
            s = s.sort_by { |e| -(e.cached_stat.gentleman_stat.final_score || -Float::INFINITY) }
          when "vitality"
            s = s.sort_by { |e| -e.cached_stat.vitality_stat.count }
          end
          s
        end
      end

      def rows
        @rows ||= ordered_scope.collect do |e|
          Rails.logger.tagged(e.key) do
            {}.tap do |row|
              row["名前"] = user_tactics_hash[e.key][:name]
              row["ウォーズID"] = { _nuxt_link: e.name_with_ban, _v_bind: { to: { name: "swars-search", query: { query: e.user_key } }, }, }
              row["最高"] = e.grade.name
              row.update(display_ranks_hash(e))
              row["勝率"] = e.cached_stat.total_judge_stat.win_ratio.try { |e| "%.0f %%" % [e * 100] }
              row["勢い"] = e.cached_stat.vitality_stat.vital_ratio.try { |e| "%.0f %%" % [e * 100] }
              row["規範"] = e.cached_stat.gentleman_stat.final_score.try { "#{floor} 点" }
              row["居飛車"]   = e.cached_stat.tag_stat.use_rate_for(:"居飛車").try { |e| "%.0f %%" % [e * 100] }
              row["振り飛車"] = e.cached_stat.tag_stat.use_rate_for(:"振り飛車").try { |e| "%.0f %%" % [e * 100] }
              row["主戦法"] = e.cached_stat.simple_matrix_stat.my_attack_tag.try { name }
              row["主囲い"] = e.cached_stat.simple_matrix_stat.my_defense_tag.try { name }
              row["直近対局"] = e.latest_battled_at&.to_fs(:ymd)
              if Rails.env.local?
                row["リンク1"] = { _nuxt_link: "棋譜(#{e.memberships.size})", _v_bind: { to: { name: "swars-search", query: { query: e.user_key } }, }, }
                row["リンク2"] = { _nuxt_link: "プレイヤー情報", _v_bind: { to: { name: "swars-users-key", params: { key: e.user_key } }, }, }
                row["リンク3"] = tag.a("本家", href: e.official_mypage_url, target: "_blank")
                row["リンク4"] = tag.a("ググる", href: e.google_search_url, target: "_blank")
              end
              if Rails.env.local?
                row["最高段位(index)"] = e.grade.pure_info.priority
              end
            end
          end
        end
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

        if current_user_keys.blank?
          flash[:notice] = "ウォーズIDを指定してください"
          return
        end

        if missing_user_keys.present?
          flash[:notice] = "#{missing_user_keys * ' と '} が見つかりません。将棋ウォーズ棋譜検索で一度検索すると出てくるかもしれません。"
          return
        end

        if main_scope.none?
          flash[:notice] = "一人も見つかりません"
          return
        end

        if main_scope.count > LIMIT_MAX
          flash[:notice] = "#{LIMIT_MAX} 人以下にしよう"
          return
        end
      end

      def main_scope
        @main_scope ||= yield_self do
          s = ::Swars::User.where(key: current_user_keys)
          s = s.includes(:grade)       # for e.grade.name
          s = s.includes(:memberships) # for e.memberships.size (存在しないのもあるため joins してはいけない)
        end
      end

      def display_ranks_hash(user)
        user.cached_stat(STAT_OPTIONS).display_rank_stat.display_ranks_hash
      end

      def current_order_by
        (params[:order_by].presence || "original").to_s
      end

      def current_google_sheet
        params[:google_sheet].to_s == "true"
      end

      def current_bg_request
        params[:bg_request].to_s == "true"
      end

      def posted_message
        "承りました。終わったら #{current_user.email} あてに URL を送ります。"
      end

      ################################################################################ 対象ウォーズIDs

      # def user_items_text_default
      #   @user_items_text_default ||= Rails.env.local? ? USER_ITEMS_TEXT_DEFAULT : ""
      # end

      def user_item_columns
        [:name, :swars_key]
      end

      def user_items
        @user_items ||= params[:user_items_text].to_s.strip.lines.collect { |e|
          if values = e.strip.split(/[[:space:],|]+/).presence
            user_item_columns.zip(values).to_h
          end
        }.compact
      end

      # 指定のウォーズID(s)
      def current_user_keys
        @current_user_keys ||= user_items.collect { |e| e[:swars_key] }
      end

      # ウォーズIDから名前を求めるためのテーブル
      def user_tactics_hash
        @user_tactics_hash ||= user_items.index_by { it[:swars_key] }
      end

      # DBに存在するユニークなウォーズIDたち
      def db_exist_user_keys
        @db_exist_user_keys ||= main_scope.distinct.pluck(:key)
      end

      # 引き数で指定したが存在しなかったウォーズIDたち
      def missing_user_keys
        current_user_keys - db_exist_user_keys
      end

      ################################################################################ Google Sheet

      def sheet_title
        "#{title}(#{main_scope.size}人)"
      end

      def sheet_rows
        @sheet_rows ||= ordered_scope.collect do |e|
          Rails.logger.tagged(e.key) do
            {}.tap do |row|
              row["名前"]            = user_tactics_hash[e.key][:name]
              row["ウォーズID"]      = hyper_link(e.name_with_ban, e.swars_search_url)
              row["最高段位"]        = e.grade.name
              row.update(display_ranks_hash(e))
              row["勝率"]            = e.cached_stat.total_judge_stat.win_ratio
              row["勢い"]            = e.cached_stat.vitality_stat.vital_ratio
              row["行動規範"]        = e.cached_stat.gentleman_stat.final_score.try { floor }
              row["居飛車"]          = e.cached_stat.tag_stat.use_rate_for(:"居飛車")
              row["振り飛車"]        = e.cached_stat.tag_stat.use_rate_for(:"振り飛車")
              row["主戦法"]          = e.cached_stat.simple_matrix_stat.my_attack_tag.try { name }
              row["主囲い"]          = e.cached_stat.simple_matrix_stat.my_defense_tag.try { name }
              row["直近対局"]        = e.latest_battled_at&.to_fs(:ymd)
              row["リンク1"]         = hyper_link("棋譜検索(#{e.memberships.size})", e.swars_search_url)
              row["リンク2"]         = hyper_link("プレイヤー情報", e.player_info_url)
              row["リンク3"]         = hyper_link("本家",           e.official_mypage_url)
              row["リンク4"]         = hyper_link("ググる",         e.google_search_url)
              row["最高段位(index)"] = e.grade.pure_info.priority
            end
          end
        end
      end

      def sheet_columns_hash
        {
          "勝率"     => { number_format: { type: "PERCENT", pattern: "0 %",        }, }, # PERCENT は自動的に100倍してくれる(0.50 → "50 %")
          "勢い"     => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          "居飛車"   => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          "振り飛車" => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          "行動規範" => { number_format: { type: "NUMBER",  pattern: "0 点",       }, }, # 0.000 にすると小数点表記になる。整数にする場合、ここだけを変更すると四捨五入になるため元を floor にすること。
          "直近対局" => { number_format: { type: "DATE",    pattern: "yyyy/MM/dd", }, },
        }
      end

      def sheet_url
        @sheet_url ||= GoogleApi::Facade.new(title: sheet_title, rows: sheet_rows, columns_hash: sheet_columns_hash).call
      end

      def sheet_url_link
        h.tag.a("Google スプレッドシートを開く", href: sheet_url, target: "_blank", :class => "tag is-primary")
      end

      def sheet_result_html
        "自動的に遷移しない場合は #{sheet_url_link} をタップしてください。モバイル Safari の場合はポップアップブロックを解除しておくと遷移するようになります。Google スプレッドシートを編集するんなら開いてから右上メニューから「共有とエクスポート」→「コピーを作成」してください。PC の場合は「ファイル」→「コピーを作成」です。"
      end

      ################################################################################

      def mail_notify
        SystemMailer.notify(subject: mail_subject, to: current_user.email, bcc: AppConfig[:admin_email], body: mail_body).deliver_later
      end

      def mail_subject
        sheet_title
      end

      def mail_body
        out = []
        out << sheet_url
        out << "生成した Google スプレッドシートは1ヶ月ほどで消します。保存しておきたい場合や編集する場合は、そこから「コピーを作成」で自分のところにコピってください。"
        # Google スプレッドシートを編集するんなら開いてから右上メニューから「共有とエクスポート」→「コピーを作成」してください。PC の場合は「ファイル」→「コピーを作成」です。
        out << ""
        out << "▼再度生成したいときのコピペ用テキスト"
        out << user_items.collect { |e| [e[:name], e[:swars_key]].join(" ") }.join("\n")
        out.join("\n")
      end

      ################################################################################
    end
  end
end

# s = ::Swars::Membership.all
# s = s.joins(:battle => :rule)
# s = s.joins(:user)
# s = s.joins(:grade)
# s = s.merge(main_scope)
# s = s.group("swars_users.user_key")
# s = s.group("rule_key")
# s = s.joins("JOIN swars_grades g ON g.id = swars_users.grade_id") if false # 最高棋力をついでに求める
# s = s.select("swars_users.user_key")                                       # ウォーズID
# s = s.select("#{::Swars::Rule.table_name}.key AS rule_key")                # 持ち時間
# s = s.select("MIN(#{::Swars::Grade.table_name}.priority) AS min_priority") # 持ち時間別の最高棋力
# s = s.select("g.key AS max_grade_key") if false                            # 最高棋力
#
# # >> |-------------+-----------+--------------+
# # >> | user_key    | rule_key  | min_priority |
# # >> |-------------+-----------+--------------+
# # >> | BOUYATETSU5 | ten_min   |            4 |
# # >> | BOUYATETSU5 | ten_sec   |            4 |
# # >> | BOUYATETSU5 | three_min |            5 |
# # >> | TOBE_CHAN   | ten_min   |            5 |
# # >> | TOBE_CHAN   | ten_sec   |           38 |
# # >> | itoshinTV   | ten_sec   |            4 |
# # >> | itoshinTV   | ten_min   |            5 |
# # >> | itoshinTV   | three_min |            3 |
# # >> |-------------+-----------+--------------+
#
# if false
#   # SQL を使って min_priority を棋力名に変換する
#   sql = <<~SQL
#   SELECT
#      dispatcher.user_key,
#      dispatcher.rule_key,
#      g.key as grade_key
#   FROM (#{s.to_sql}) dispatcher
#   JOIN swars_grades g ON g.priority = dispatcher.min_priority
# SQL
#   hv = ActiveRecord::Base.connection.select_all(sql).each_with_object({}) do |e, m|
#     e = e.symbolize_keys
#     m[e[:user_key]] ||= {}
#     m[e[:user_key]][e[:rule_key].to_sym] = e[:grade_key]
#   end
# else
#   # SQL を使わずに棋力名に変換する
#   hv = s.each_with_object({}) do |e, m|
#     m[e.user_key] ||= {}
#     m[e.user_key][e.rule_key.to_sym] = ::Swars::GradeInfo.fetch(e.min_priority).name
#   end
# end
#
# s = main_scope
# s = s.includes(:grade)
# rows = s.collect do |e|
#   row = {}
#   row["名前"] = { _nuxt_link: e.key, _v_bind: { to: {name: "swars-users-key", params: { key: e.user_key } }, }, }
#   row["最高"] = e.grade.name
#   ::Swars::RuleInfo.each do |rule_info|
#     row[rule_info.name] = hv.dig(e.user_key, rule_info.key) || "?"
#   end
#   row["index"] = e.grade.pure_info.priority
#   row
# end

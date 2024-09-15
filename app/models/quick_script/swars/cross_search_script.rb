module QuickScript
  module Swars
    class CrossSearchScript < Base
      self.title                         = "将棋ウォーズ横断検索"
      self.description                   = "ウォーズIDを指定しない検索"
      self.form_method                   = :post # GET にすると json でこないので空配列が nil になってしまって session_sync がバグる
      self.router_push_failed_then_fetch = true
      self.button_label                  = "実行"
      self.login_link_show               = true
      self.debug_mode                    = Rails.env.local?
      self.throttle_expires_in           = 5.0
      self.params_add_submit_key         = :exec
      self.parent_link                   = { to: "/swars/search" } # { go_back: true }

      WANT_MAX_DEFAULT     = 50      # 抽出希望件数は N 以下
      WANT_MAX_MAX         = 500     # 抽出希望件数は N 以下
      RANGE_MAX_THRESHOLD = 10000   # N以上ならバックグラウンド実行する
      RANGE_MAX_MAX        = 100000  # 対象件数は N 以下

      def form_parts
        super + [
          ################################################################################

          {
            :label        => "戦法",
            :key          => :x_tag,
            :type         => :string,
            :ac_by        => :html5,
            :elems        => candidate_tag_names,
            :default      => params[:x_tag].presence,
            :help_message => "直接入力 or 右端の▼から選択。複数指定可。",
            :session_sync => true,
          },
          {
            :label        => "戦法の解釈",
            :key          => :x_tag_cond_key,
            :type         => :radio_button,
            :elems        => TagCondInfo.to_form_elems,
            :default      => x_tag_cond_key,
            :session_sync => true,
          },
          {
            :label        => "棋力",
            :key          => :x_grade_keys,
            :type         => :checkbox_button,
            :elems        => ::Swars::GradeInfo.find_all(&:select_option).reverse.inject({}) { |a, e| a.merge(e.key => e.to_form_elem) },
            :default      => x_grade_keys,
            # :help_message => "指定の戦法を使った人の棋力",
            :session_sync => true,
          },
          {
            :label        => "勝敗",
            :key          => :x_judge_keys,
            :type         => :checkbox_button,
            :elems        => ::JudgeInfo.to_form_elems,
            :default      => x_judge_keys,
            # :help_message => "スタイルは membership に結び付く",
            :session_sync => true,
          },
          {
            :label        => "スタイル",
            :key          => :x_style_keys,
            :type         => :checkbox_button,
            :elems        => ::Swars::StyleInfo.to_form_elems,
            :default      => x_style_keys,
            # :help_message => "「戦法」欄で具体的な戦法や囲いを指定している場合、その時点でほぼスタイルが確定している",
            :session_sync => true,
          },
          {
            :label        => "ウォーズIDs",
            :key          => :x_user_keys,
            :type         => :string,
            :default      => params[:x_user_keys].presence,
            :help_message => "複数指定可 (ここで一人だけ指定するなら通常の棋譜検索を使った方がいい)",
            :session_sync => true,
          },

          ################################################################################

          {
            :label        => "相手の戦法",
            :key          => :y_tag,
            :type         => :string,
            :ac_by        => :html5,
            :elems        => candidate_tag_names,
            :default      => params[:y_tag].presence,
            :help_message => "直接入力 or 右端の▼から選択。複数指定可。",
            :session_sync => true,
          },
          {
            :label        => "相手の戦法の解釈",
            :key          => :y_tag_cond_key,
            :type         => :radio_button,
            :elems        => TagCondInfo.to_form_elems,
            :default      => y_tag_cond_key,
            :session_sync => true,
          },
          {
            :label        => "相手の棋力",
            :key          => :y_grade_keys,
            :type         => :checkbox_button,
            :elems        => ::Swars::GradeInfo.find_all(&:select_option).reverse.inject({}) { |a, e| a.merge(e.key => e.to_form_elem) },
            :default      => y_grade_keys,
            # :help_message => "指定の戦法を食らった人の棋力",
            :session_sync => true,
          },
          {
            :label        => "相手の勝敗",
            :key          => :y_judge_keys,
            :type         => :checkbox_button,
            :elems        => ::JudgeInfo.to_form_elems,
            :default      => y_judge_keys,
            # :help_message => "指定の戦法を使ったときの勝敗",
            :session_sync => true,
          },
          {
            :label        => "相手のスタイル",
            :key          => :y_style_keys,
            :type         => :checkbox_button,
            :elems        => ::Swars::StyleInfo.to_form_elems,
            :default      => y_style_keys,
            # :help_message => "「相手の戦法」欄で具体的な戦法や囲いを指定している場合、その時点でほぼスタイルが確定している",
            :session_sync => true,
          },
          {
            :label        => "相手のウォーズIDs",
            :key          => :y_user_keys,
            :type         => :string,
            :default      => params[:y_user_keys].presence,
            :help_message => "複数指定可",
            :session_sync => true,
          },
          ################################################################################

          {
            :label        => "モード",
            :key          => :xmode_keys,
            :type         => :checkbox_button,
            :elems        => ::Swars::XmodeInfo.to_form_elems,
            :default      => xmode_keys,
            :session_sync => true,
          },

          {
            :label        => "持ち時間",
            :key          => :rule_keys,
            :type         => :checkbox_button,
            :elems        => ::Swars::RuleInfo.to_form_elems,
            :default      => rule_keys,
            :session_sync => true,
          },

          {
            :label        => "手合割",
            :key          => :preset_keys,
            :type         => :checkbox_button,
            :elems        => PresetInfo.swars_preset_infos.inject({}) { |a, e| a.merge(e.key => e.to_form_elem) },
            :default      => preset_keys,
            :session_sync => true,
          },

          {
            :label        => "結末",
            :key          => :final_keys,
            :type         => :checkbox_button,
            :elems        => ::Swars::FinalInfo.to_form_elems,
            :default      => final_keys,
            :session_sync => true,
          },

          {
            :label        => "おまけクエリ",
            :key          => :query,
            :type         => :string,
            :default      => query,
            :placeholder  => "開戦:>=21 中盤:>=42 手数:>=89",
            :help_message => "棋譜検索と似た検索クエリを指定する。指定できるのは両対局者の共通の情報のみ。",
            :session_sync => true,
          },
          ################################################################################

          {
            :label        => "検索対象件数 - 直近N件",
            :key          => :range_max,
            :type         => :numeric,
            :options      => { min: 10000, max: RANGE_MAX_MAX, step: 10000 },
            :default      => range_max,
            :help_message => "この件数の中から抽出希望件数分の対局を探す。出てこないときはこの上限を増やそう",
            :session_sync => true,
          },
          {
            :label        => "抽出希望件数",
            :key          => :want_max,
            :type         => :numeric,
            :options      => { min: 50, max: WANT_MAX_MAX, step: 50 },
            :default      => want_max,
            :help_message => "これだけ見つけたら検索を終える",
            :session_sync => true,
          },

          ################################################################################

          {
            :label        => "ZIPダウンロード",
            :key          => :download_key,
            :type         => :radio_button,
            :elems        => DownloadInfo.to_form_elems,
            :default      => download_key,
            :session_sync => true,
          },

          {
            :label        => "バックグラウンド実行",
            :key          => :bg_request_key,
            :type         => :radio_button,
            :elems        => BgRequestInfo.to_form_elems,
            :default      => bg_request_key,
            :session_sync => true,
          },
        ]
      end

      def call
        if running_in_foreground && submitted? && fetch_index >= 0
          validate!
          if flash.present?
            return
          end
          if bg_request_info.key == :on
            unless throttle.call
              flash[:notice] = "連打すな"
              return
            end
            call_later
            # self.form_method = nil # form をまるごと消す
            flash[:notice] = posted_message
            return
          end
          first_heavy_process_execute
          foreground_execute_log
          if found_ids.empty?
            flash[:notice] = empty_message
            return
          end
          if download_info.key == :on
            flash[:notice] = "ダウンロードを開始しました"
            redirect_to download_url, type: :hard
            return
          else
            flash[:notice] = found_message
            redirect_to search_path, type: :tab_open
            return { _v_html: result_html }
          end
        end
        if running_in_background
          mail_notify
        end
      end

      def posted_message
        "承りました。終わったら #{current_user.email} あてに一報します。"
      end

      def validate!
        all_tag_names.each do |tag_name|
          unless Bioshogi::Explain::TacticInfo.flat_lookup(tag_name)
            flash[:notice] = "#{tag_name}とはなんでしょう？"
            return
          end
        end

        all_user_keys.each do |user_key|
          unless ::Swars::User.exists?(key: user_key)
            flash[:notice] = "#{user_key} さんは見つかりません。ウォーズIDが間違っていませんか？"
            return
          end
        end

        ################################################################################

        if range_max > RANGE_MAX_MAX
          flash[:notice] = "検索対象件数は#{RANGE_MAX_MAX}件以下にしてください"
          return
        end
        if range_max > RANGE_MAX_THRESHOLD
          if bg_request_info.key == :off
            flash[:notice] = "検索対象件数が#{RANGE_MAX_THRESHOLD}件を越える場合はバックグラウンド実行してください"
            return
          end
        end

        ################################################################################

        if want_max > WANT_MAX_MAX
          flash[:notice] = "抽出希望件数は#{WANT_MAX_MAX}件以下にしてください"
          return
        end

        if params[:experiment]
          if want_max > WANT_MAX_DEFAULT
            if download_info.key == :on && bg_request_info.key == :off
              flash[:notice] = "#{WANT_MAX_DEFAULT}件を越える件数をZIPダウンロードする場合はバックグラウンド実行してください"
              return
            end
          end
        end

        ################################################################################

        unless params[:experiment]
          if download_info.key == :on && bg_request_info.key == :off
            flash[:notice] = "ZIPダウンロードする場合はバックグラウンド実行してください"
            return
          end
        end

        ################################################################################

        if bg_request_info.key == :on
          unless current_user
            flash[:notice] = "バックグラウンド実行する場合は結果をメールするのでログインしてください"
            return
          end
          unless current_user.email_valid?
            flash[:notice] = "ちゃんとしたメールアドレスを登録してください"
            return
          end
        end
      end

      def first_heavy_process_execute
        if @processed_at
          raise "must not happen"
        end
        @processed_at = Time.current
        @processed_second = Benchmark.realtime { found_ids }
        if download_info.key == :on
          download_content
        end
      end

      def found_ids
        @found_ids ||= yield_self do
          ids = []
          ::Swars::Battle.in_batches(of: batch_size, order: :desc).each.with_index do |relation, i|
            if i >= batch_loop_max
              break
            end
            ids += sub_scope(relation).ids
            if ids.size >= want_max
              break
            end
          end
          ids.take(want_max)
        end
      end

      def sub_scope(scope)
        scope = battle_scope(scope)

        memberships = ::Swars::Membership.where(battle: scope.ids)

        x = memberships_scope_by(memberships, x_tag_names, x_tag_cond_info, x_judge_infos, x_style_infos, x_grade_infos, x_user_keys)
        y = memberships_scope_by(memberships, y_tag_names, y_tag_cond_info, y_judge_infos, y_style_infos, y_grade_infos, y_user_keys)

        s = x.where(opponent: y.ids) # ids を明示すると速くなる(317ms → 101ms)

        if true
          # distinct を使う場合。こっちの方が 10 ms 速い。
          scope = scope.joins(:memberships).distinct.merge(s) # distinct 重要
        else
          # distinct を使いたくないので再度 id で引く
          scope = scope.where(id: scope.joins(:memberships).merge(s).ids)
        end

        scope = scope.find_all_by_query(query)
      end

      def battle_scope(scope)
        scope.then do |s|
          if v = xmode_infos.presence
            s = s.xmode_eq(v.pluck(:key))
          end
          if v = rule_infos.presence
            s = s.rule_eq(v.pluck(:key))
          end
          if v = preset_infos.presence
            s = s.preset_eq(v.pluck(:key))
          end
          if v = final_infos.presence
            s = s.final_eq(v.pluck(:key))
          end
          s
        end
      end

      def memberships_scope_by(memberships, tag_names, tag_cond_info, judge_infos, style_infos, grade_infos, user_keys)
        memberships.then do |s|
          if v = tag_names.presence
            s = s.tagged_with(v, tag_cond_info.tagged_with_options)
          end
          if v = judge_infos.presence
            s = s.judge_eq(v.pluck(:key))
          end
          if v = style_infos.presence
            s = s.style_eq(v.pluck(:key))
          end
          if v = grade_infos.presence
            s = s.grade_eq(v.pluck(:key))
          end
          if v = user_keys.presence
            s = s.where(user: ::Swars::User.where(key: v))
          end
          s
        end
      end

      ################################################################################

      def x_tag_names
        @x_tag_names ||= tag_string_split(params[:x_tag])
      end

      def y_tag_names
        @y_tag_names ||= tag_string_split(params[:y_tag])
      end

      def all_tag_names
        x_tag_names + y_tag_names
      end

      def tag_string_split(str)
        unless str.kind_of?(Array)
          str = str.to_s.split(/[,[:blank:]]+/)
        end
        str.uniq
      end

      def candidate_tag_names
        @candidate_tag_names ||= [:attack, :defense, :technique, :note].flat_map { |e| Bioshogi::Explain::TacticInfo[e].model.collect(&:name) }
      end

      ################################################################################

      def x_user_keys
        @x_user_keys ||= user_keys_wrap(params[:x_user_keys])
      end

      def y_user_keys
        @y_user_keys ||= user_keys_wrap(params[:y_user_keys])
      end

      def all_user_keys
        x_user_keys + y_user_keys
      end

      def user_keys_wrap(str)
        unless str.kind_of?(Array)
          str = str.to_s.scan(/\w+/)
        end
        str.uniq
      end

      ################################################################################

      def x_judge_keys
        tag_string_split(params[:x_judge_keys])
      end

      def x_judge_infos
        @x_judge_infos ||= ::JudgeInfo.array_from(x_judge_keys)
      end

      ################################################################################

      def y_judge_keys
        tag_string_split(params[:y_judge_keys])
      end

      def y_judge_infos
        @y_judge_infos ||= ::JudgeInfo.array_from(y_judge_keys)
      end

      ################################################################################

      def x_style_keys
        tag_string_split(params[:x_style_keys])
      end

      def x_style_infos
        @x_style_infos ||= ::Swars::StyleInfo.array_from(x_style_keys)
      end

      ################################################################################

      def y_style_keys
        tag_string_split(params[:y_style_keys])
      end

      def y_style_infos
        @y_style_infos ||= ::Swars::StyleInfo.array_from(y_style_keys)
      end

      ################################################################################

      def x_grade_keys
        tag_string_split(params[:x_grade_keys])
      end

      def x_grade_infos
        @x_grade_infos ||= ::Swars::GradeInfo.array_from(x_grade_keys)
      end

      ################################################################################

      def y_grade_keys
        tag_string_split(params[:y_grade_keys])
      end

      def y_grade_infos
        @y_grade_infos ||= ::Swars::GradeInfo.array_from(y_grade_keys)
      end

      ################################################################################

      def x_tag_cond_key
        TagCondInfo.lookup_key_or_first(params[:x_tag_cond_key])
      end

      def x_tag_cond_info
        @x_tag_cond_info ||= TagCondInfo.fetch(x_tag_cond_key)
      end

      ################################################################################

      def y_tag_cond_key
        TagCondInfo.lookup_key_or_first(params[:y_tag_cond_key])
      end

      def y_tag_cond_info
        @y_tag_cond_info ||= TagCondInfo.fetch(y_tag_cond_key)
      end

      ################################################################################ モード

      def xmode_keys
        tag_string_split(params[:xmode_keys])
      end

      def xmode_infos
        @xmode_infos ||= ::Swars::XmodeInfo.array_from(xmode_keys)
      end

      ################################################################################ 持ち時間

      def rule_keys
        tag_string_split(params[:rule_keys])
      end

      def rule_infos
        @rule_infos ||= ::Swars::RuleInfo.array_from(rule_keys)
      end

      ################################################################################ 手合割

      def preset_keys
        tag_string_split(params[:preset_keys])
      end

      def preset_infos
        @preset_infos ||= PresetInfo.array_from(preset_keys)
      end

      ################################################################################ 結末

      def final_keys
        tag_string_split(params[:final_keys])
      end

      def final_infos
        @final_infos ||= ::Swars::FinalInfo.array_from(final_keys)
      end

      ################################################################################

      def want_max
        (params[:want_max].presence || WANT_MAX_DEFAULT).to_i
      end

      def range_max
        (params[:range_max].presence || RANGE_MAX_THRESHOLD).to_i
      end

      ################################################################################

      def download_key
        DownloadInfo.lookup_key_or_first(params[:download_key])
      end

      def download_info
        DownloadInfo.fetch(download_key)
      end

      ################################################################################

      def bg_request_key
        BgRequestInfo.lookup_key_or_first(params[:bg_request_key])
      end

      def bg_request_info
        BgRequestInfo.fetch(bg_request_key)
      end

      ################################################################################

      def query
        params[:query].to_s
      end

      ################################################################################

      def batch_size
        1000
      end

      def batch_loop_max
        @batch_loop_max ||= range_max.ceildiv(batch_size)
      end

      ################################################################################

      def foreground_execute_log
        AppLog.important(emoji: ":REALTIME:", subject: mail_subject, body: mail_body)
      end

      ################################################################################

      def empty_message
        out = []
        out << "ひとつも見つかりませんでした。"
        out << advice_message
        out.compact.join("\n")
      end

      def advice_message
        if x_tag_names.present? && x_style_infos.present?
          return "「戦法」欄で具体的な戦法や囲いを指定している場合、その時点でほぼスタイルが確定しているため、「スタイル」の指定は外した方がいいかもしれません。"
        end
        if y_tag_names.present? && y_style_infos.present?
          return "「相手の戦法」欄で具体的な戦法や囲いを指定している場合、その時点でほぼスタイルが確定しているため、「相手のスタイル」の指定は外した方がいいかもしれません。"
        end
        return "条件を緩くするか、「検索対象件数」を増やしてみてください。"
      end

      def link_to_search_url
        h.tag.a("ここ", href: search_url, target: "_blank", :class => "tag is-primary")
      end

      def result_html
        "自動的に遷移しない場合は #{link_to_search_url} をタップしてください (モバイル Safari の場合は忌しいポップアップブロックを解除しておくと快適になります)"
      end

      ################################################################################

      def mail_notify
        first_heavy_process_execute
        SystemMailer.notify({
            :emoji       => ":検索:",
            :subject     => mail_subject,
            :body        => mail_body,
            :to          => current_user.email,
            :bcc         => AppConfig[:admin_email],
            :attachments => mail_attachments,
          }).deliver_now        # deliver_later では download_content のシリアライズの関係でエラーになる
      end

      def mail_attachments
        if download_info.key == :on
          { download_filename => download_content }
        end
      end

      def mail_subject
        "【将棋ウォーズ横断検索】抽出#{found_ids.size}件"
      end

      def found_message
        "#{found_ids.size}件見つかりました"
      end

      def mail_body
        out = []
        if found_ids.empty?
          out << empty_message
        else
          out << search_url
        end
        out << ""
        out << info.collect { |k, v| "#{k}: #{v}" }.join("\n")
        out.join("\n")
      end

      def info
        {
          # -------------------------------------------------------------------------------- 対象
          "戦法"                 => x_tag_names,
          "戦法の解釈"           => x_tag_names.presence&.then { x_tag_cond_info.name },
          "棋力"                 => x_grade_infos.collect(&:name),
          "勝敗"                 => x_judge_infos.collect(&:name),
          "スタイル"             => x_style_infos.collect(&:name),
          "ウォーズIDs"          => x_user_keys,
          # -------------------------------------------------------------------------------- 相手
          "相手の戦法"           => y_tag_names,
          "相手の戦法の解釈"     => y_tag_names.presence&.then { y_tag_cond_info.name },
          "相手の棋力"           => y_grade_infos.collect(&:name),
          "相手の勝敗"           => y_judge_infos.collect(&:name),
          "相手のスタイル"       => y_style_infos.collect(&:name),
          "相手のウォーズIDs"    => y_user_keys,
          # -------------------------------------------------------------------------------- バトルに対して
          "モード"               => xmode_infos.collect(&:name),
          "持ち時間"             => rule_infos.collect(&:name),
          "手合割"               => preset_infos.collect(&:name),
          "結末"                 => final_infos.collect(&:name),
          "おまけクエリ"         => query,
          # -------------------------------------------------------------------------------- フォーム
          "検索対象件数"         => range_max,
          "抽出希望件数"         => want_max,
          # -------------------------------------------------------------------------------- 受け取り方法
          "ZIPダウンロード"      => download_info.name,
          "バックグラウンド実行" => bg_request_info.name,
          # -------------------------------------------------------------------------------- 結果
          "抽出"                 => found_ids.size,
          # -------------------------------------------------------------------------------- 時間
          "実行開始"             => @processed_at.try { to_fs(:ymdhms) },
          "処理時間"             => @processed_second.try { ActiveSupport::Duration.build(self).inspect },
        }.compact_blank
      end

      def search_url
        UrlProxy.full_url_for(search_path)
      end

      def search_path
        query = "id:" + found_ids * ","
        "/swars/search" + "?" + { query: query }.to_query
      end

      ################################################################################

      def download_key
        DownloadInfo.lookup_key_or_first(params[:download_key])
      end

      def download_info
        DownloadInfo.fetch(download_key)
      end

      ################################################################################

      def render_format(format)
        super
        format.zip do
          controller.send_data(download_content, {
              :type        => Mime["zip"],
              :filename    => download_filename,
              :disposition => "attachment",
            })
        end
      end

      def download_filename
        @download_filename ||= FilenameBuilder.new(self).call
      end

      def download_content
        to_zip.string
      end

      def download_url
        query = params.except(:controller, :action, :format, :_method)
        self.class.qs_api_url(:zip) + "?" + query.to_query
      end

      def zip_builder
        ZipBuilder.new(self)
      end

      def to_zip
        @to_zip ||= yield_self do
          io = nil
          processed_second = Benchmark.realtime { io = zip_builder.to_blob }
          AppLog.important(subject: "ZIP生成 (#{found_ids.size})", body: ActiveSupport::Duration.build(processed_second).inspect)
          io
        end
      end

      ################################################################################
    end
  end
end

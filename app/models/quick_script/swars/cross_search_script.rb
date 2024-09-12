module QuickScript
  module Swars
    class CrossSearchScript < Base
      self.title                         = "将棋ウォーズ横断検索"
      self.description                   = "ウォーズIDを指定しない検索"
      self.form_method                   = :post # GET にすると json でこないので空配列が nil になってしまって session_sync がバグる
      self.router_push_failed_then_fetch = true
      self.button_label                  = "検索"
      self.login_link_show               = true
      self.debug_mode                    = Rails.env.local?
      self.throttle_expires_in           = 5.0
      self.params_add_submit_key         = :exec
      self.parent_link                   = { to: "/swars/search" } # { go_back: true }

      MAX_OF_WANT_MAX      = 500     # 抽出希望件数は N 以下
      BACKGROUND_THRESHOLD = 10000   # N以上ならバックグラウンド実行する
      MAX_OF_RANGE_MAX     = 100000  # 対象件数は N 以下

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
            # :help_message => "指定の戦法を使ったときの勝敗",
            :session_sync => true,
          },
          {
            :label        => "スタイル",
            :key          => :x_style_keys,
            :type         => :checkbox_button,
            :elems        => ::Swars::StyleInfo.to_form_elems,
            :default      => x_style_keys,
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
            :placeholder  => "開戦:>=21 中盤:>=42 手数:>=89 手合割:二枚落ち",
            :help_message => "棋譜検索と似た検索クエリを指定する。指定できるのは両対局者の共通の情報のみ。",
            :session_sync => true,
          },
          ################################################################################

          {
            :label        => "検索対象件数 - 直近N件",
            :key          => :range_max,
            :type         => :numeric,
            :options      => { min: 10000, max: MAX_OF_RANGE_MAX, step: 10000 },
            :default      => range_max,
            :help_message => "この件数の中から抽出希望件数分の対局を探す。出てこないときはこの上限を増やそう",
            :session_sync => true,
          },
          {
            :label        => "抽出希望件数",
            :key          => :want_max,
            :type         => :numeric,
            :options      => { min: 50, max: MAX_OF_WANT_MAX, step: 50 },
            :default      => want_max,
            :help_message => "これだけ見つけたら検索を終える",
            :session_sync => true,
          },

          ################################################################################

          {
            :label   => "バックグラウンド実行",
            :key     => :bg_request,
            :type    => :radio_button,
            :elems   => {
              "false" => { el_label: "しない", el_message: "リアルタイムで結果を得る",     },
              "true"  => { el_label: "する",   el_message: "あとで結果をメールで受け取る", },
            },
            :default => params[:bg_request].to_s.presence || "false",
            :session_sync => true,
          },
        ]
      end

      def call
        if foreground_mode && submitted? && fetch_index >= 0
          validate!
          if flash.present?
            return
          end
          if current_bg_request
            unless throttle.call
              flash[:notice] = "連打すな"
              return
            end
            call_later
            # self.form_method = nil # form をまるごと消す
            flash[:notice] = posted_message
            return
          end
          first_heavy_run
          app_log_call
          if found_ids.empty?
            flash[:notice] = empty_message
            return
          end
          flash[:notice] = found_message
          redirect_to search_path, type: :tab_open
          return { _v_html: result_html }
        end
        if background_mode
          mail_notify
        end
      end

      def current_bg_request
        params[:bg_request].to_s == "true"
      end

      def posted_message
        "承りました。終わったら #{current_user.email} あてに一報します。"
      end

      def validate!
        x_tag_names.each do |tag_name|
          unless Bioshogi::Explain::TacticInfo.flat_lookup(tag_name)
            flash[:notice] = "#{tag_name}とはなんでしょう？"
            return
          end
        end
        if want_max > MAX_OF_WANT_MAX
          flash[:notice] = "抽出希望件数は#{MAX_OF_WANT_MAX}以下にしてください"
          return
        end
        if range_max > MAX_OF_RANGE_MAX
          flash[:notice] = "対象件数は#{MAX_OF_RANGE_MAX}以下にしてください"
          return
        end
        if range_max > BACKGROUND_THRESHOLD
          if !current_bg_request
            flash[:notice] = "#{BACKGROUND_THRESHOLD.next}件以上を対象するとき場合はバックグラウンド実行してください"
            return
          end
        end
        if current_bg_request
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

      def first_heavy_run
        if @processed_at
          raise "must not happen"
        end
        @processed_at = Time.current
        @processed_second = Benchmark.realtime { found_ids }
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
        scope = scope.then do |s|
          if v = xmode_infos.presence
            s = s.xmode_eq(v.pluck(:key))
          end
          if v = rule_infos.presence
            s = s.rule_eq(v.pluck(:key))
          end
          if v = final_infos.presence
            s = s.final_eq(v.pluck(:key))
          end
          s
        end

        memberships = ::Swars::Membership.where(battle: scope.ids)

        x = memberships_scope_by(memberships, x_tag_names, x_tag_cond_info, x_judge_infos, x_style_infos, x_grade_infos)
        y = memberships_scope_by(memberships, y_tag_names, y_tag_cond_info, y_judge_infos, y_style_infos, y_grade_infos)

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

      def memberships_scope_by(memberships, tag_names, tag_cond_info, judge_infos, style_infos, grade_infos)
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
          s
        end
      end

      ################################################################################

      def x_tag_names
        @x_tag_names ||= array_from_tag_string(params[:x_tag])
      end

      def y_tag_names
        @y_tag_names ||= array_from_tag_string(params[:y_tag])
      end

      def array_from_tag_string(str)
        unless str.kind_of?(Array)
          str = str.to_s.split(/[,[:blank:]]+/)
        end
        str.uniq
      end

      def candidate_tag_names
        @candidate_tag_names ||= [:attack, :defense, :technique, :note].flat_map { |e| Bioshogi::Explain::TacticInfo[e].model.collect(&:name) }
      end

      ################################################################################

      def query
        params[:query].to_s
      end

      ################################################################################

      def x_judge_keys
        array_from_tag_string(params[:x_judge_keys])
      end

      def x_judge_infos
        @x_judge_infos ||= ::JudgeInfo.array_from(x_judge_keys)
      end

      ################################################################################

      def y_judge_keys
        array_from_tag_string(params[:y_judge_keys])
      end

      def y_judge_infos
        @y_judge_infos ||= ::JudgeInfo.array_from(y_judge_keys)
      end

      ################################################################################

      def x_style_keys
        array_from_tag_string(params[:x_style_keys])
      end

      def x_style_infos
        @x_style_infos ||= ::Swars::StyleInfo.array_from(x_style_keys)
      end

      ################################################################################

      def y_style_keys
        array_from_tag_string(params[:y_style_keys])
      end

      def y_style_infos
        @y_style_infos ||= ::Swars::StyleInfo.array_from(y_style_keys)
      end

      ################################################################################

      def x_grade_keys
        array_from_tag_string(params[:x_grade_keys])
      end

      def x_grade_infos
        @x_grade_infos ||= ::Swars::GradeInfo.array_from(x_grade_keys)
      end

      ################################################################################

      def y_grade_keys
        array_from_tag_string(params[:y_grade_keys])
      end

      def y_grade_infos
        @y_grade_infos ||= ::Swars::GradeInfo.array_from(y_grade_keys)
      end

      ################################################################################

      def x_tag_cond_key
        TagCondInfo.valid_key_or_first(params[:x_tag_cond_key])
      end

      def x_tag_cond_info
        @x_tag_cond_info ||= TagCondInfo.fetch(x_tag_cond_key)
      end

      ################################################################################

      def y_tag_cond_key
        TagCondInfo.valid_key_or_first(params[:y_tag_cond_key])
      end

      def y_tag_cond_info
        @y_tag_cond_info ||= TagCondInfo.fetch(y_tag_cond_key)
      end

      ################################################################################

      def rule_keys
        array_from_tag_string(params[:rule_keys])
      end

      def rule_infos
        @rule_infos ||= ::Swars::RuleInfo.array_from(rule_keys)
      end

      ################################################################################

      def final_keys
        array_from_tag_string(params[:final_keys])
      end

      def final_infos
        @final_infos ||= ::Swars::FinalInfo.array_from(final_keys)
      end

      ################################################################################

      def xmode_keys
        array_from_tag_string(params[:xmode_keys])
      end

      def xmode_infos
        @xmode_infos ||= ::Swars::XmodeInfo.array_from(xmode_keys)
      end

      ################################################################################

      def want_max
        (params[:want_max].presence || 50).to_i
      end

      def range_max
        (params[:range_max].presence || BACKGROUND_THRESHOLD).to_i
      end

      def batch_size
        1000
      end

      def batch_loop_max
        @batch_loop_max ||= range_max.ceildiv(batch_size)
      end

      ################################################################################

      def app_log_call
        AppLog.important(emoji: ":REALTIME:", subject: mail_subject, body: mail_body)
      end

      ################################################################################

      def empty_message
        "ひとつも見つかりませんでした"
      end

      def safari_user_message
        "#{search_url}"
      end

      def link_to_search_url
        h.tag.a("ここ", href: search_url, target: "_blank", :class => "tag is-primary")
      end

      def result_html
        "自動的に遷移しない場合は #{link_to_search_url} をタップしてください (モバイル Safari の場合は忌しいポップアップブロックを解除しておくと快適になります)"
      end

      ################################################################################

      def mail_notify
        first_heavy_run
        SystemMailer.notify({
            :emoji   => ":検索:",
            :subject => mail_subject,
            :body    => mail_body,
            :to      => current_user.email,
            :bcc     => AppConfig[:admin_email],
          }).deliver_later
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
          "戦法の解釈"           => x_tag_cond_info.name,
          "棋力"                 => x_grade_infos.collect(&:name),
          "勝敗"                 => x_judge_infos.collect(&:name),
          "スタイル"             => x_style_infos.collect(&:name),
          # -------------------------------------------------------------------------------- 相手
          "相手の戦法"           => y_tag_names,
          "相手の戦法の解釈"     => y_tag_cond_info.name,
          "相手の棋力"           => y_grade_infos.collect(&:name),
          "相手の勝敗"           => y_judge_infos.collect(&:name),
          "相手のスタイル"       => y_style_infos.collect(&:name),
          # -------------------------------------------------------------------------------- バトルに対して
          "モード"               => xmode_infos.collect(&:name),
          "持ち時間"             => rule_infos.collect(&:name),
          "結末"                 => final_infos.collect(&:name),
          "おまけクエリ"         => query,
          # -------------------------------------------------------------------------------- フォーム
          "検索対象件数"         => range_max,
          "抽出希望件数"         => want_max,
          "バックグラウンド実行" => current_bg_request,
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
    end
  end
end

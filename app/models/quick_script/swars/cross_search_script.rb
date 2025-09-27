# http://localhost:4000/lab/swars/cross-search

module QuickScript
  module Swars
    class CrossSearchScript < Base
      self.title                         = "横断棋譜検索"
      self.description                   = "ウォーズIDを指定しない検索"
      self.form_method                   = :get
      self.router_push_failed_then_fetch = true
      self.button_label                  = "実行"
      self.login_link_show               = true
      self.debug_mode                    = Rails.env.local?
      self.throttle_expires_in           = 5.0
      self.title_click_behaviour                    = nil

      RANGE_SIZE_DEFAULT   = 10000   # 初期値
      RANGE_SIZE_THRESHOLD = 30000   # N以上ならバックグラウンド実行する
      RANGE_SIZE_MAX       = 100000  # 対象件数は N 以下
      REQUEST_SIZE_DEFAULT = 50      # 抽出希望件数初期値
      REQUEST_SIZE_MAX     = 200     # 抽出希望件数は N 以下

      def form_parts
        super + [
          ################################################################################

          {
            :label        => "自分のタグ",
            :key          => :x_tags,
            :type         => :b_taginput,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems        => candidate_tag_names,
                :default      => x_tag_names,
                :help_message => "⏎で確定。複数指定可。",
              }
            },
          },
          {
            :label        => "自分のタグの解釈",
            :key          => :x_tags_cond_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => TagCondInfo.form_part_elems,
                :default => x_tag_cond_info.key,
              }
            },
          },
          {
            :label        => "自分の棋力",
            :key          => :x_grade_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ::Swars::GradeInfo.find_all(&:select_option).reverse.inject({}) { |a, e| a.merge(e.key => e.to_form_elem) },
                :default => x_grade_infos.collect(&:key),
              }
            },
          },
          {
            :label        => "自分の勝敗",
            :key          => :x_judge_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ::JudgeInfo.form_part_elems,
                :default => x_judge_infos.collect(&:key),
              }
            },
          },
          {
            :label        => "自分の先後",
            :key          => :x_location_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => LocationInfo.form_part_elems,
                :default => x_location_infos.collect(&:key),
              }
            },
          },
          {
            :label        => "自分のスタイル",
            :key          => :x_style_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ::Swars::StyleInfo.form_part_elems,
                :default => x_style_infos.collect(&:key),
                :help_message => "「自分のタグ」欄を入力した場合、それでスタイルはすでに絞られているため、ここでさらにスタイルを指定するのは意味がありません",
              }
            },
          },
          {
            :label        => "自分のウォーズIDs",
            :key          => :x_user_keys,
            :type         => :string,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :default => params[:x_user_keys].presence,
                :help_message => "複数指定可 (ここで一人だけ指定するなら通常の棋譜検索を使った方がいい)",
              }
            },
          },

          ################################################################################

          {
            :label        => "相手のタグ",
            :key          => :y_tags,
            :type         => :b_taginput,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems        => candidate_tag_names,
                :default      => y_tag_names,
                :help_message => "⏎で確定。複数指定可。",
              }
            },
          },
          {
            :label        => "相手のタグの解釈",
            :key          => :y_tags_cond_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => TagCondInfo.form_part_elems,
                :default => y_tag_cond_info.key,
              }
            }
          },
          {
            :label        => "相手の棋力(差)",
            :key          => :x_grade_diff_key,
            :type         => :select,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => { "" => "" }.merge(GradeDiffInfo.form_part_elems),
                :default => x_grade_diff_info.try { key },
              }
            },
          },
          {
            :label        => "相手の棋力",
            :key          => :y_grade_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ::Swars::GradeInfo.find_all(&:select_option).reverse.inject({}) { |a, e| a.merge(e.key => e.to_form_elem) },
                :default => y_grade_infos.collect(&:key),
              }
            },
          },
          # {
          #   :label        => "相手の勝敗",
          #   :key          => :y_judge_keys,
          #   :type         => :checkbox_button,
          #   :session_sync => true,
          #   :dynamic_part => -> {
          #     {
          #       :elems   => ::JudgeInfo.form_part_elems,
          #       :default => y_judge_infos.collect(&:key),
          #     }
          #   },
          # },
          {
            :label        => "相手のスタイル",
            :key          => :y_style_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems        => ::Swars::StyleInfo.form_part_elems,
                :default      => y_style_infos.collect(&:key),
                :help_message => "「相手のタグ」欄を入力した場合、そこでスタイルはすでに絞られているため、ここでさらにスタイルは指定しない方がよい",
              }
            },
          },
          {
            :label        => "相手のウォーズIDs",
            :key          => :y_user_keys,
            :type         => :string,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :default => params[:y_user_keys].presence,
                :help_message => "複数指定可",
              }
            },
          },

          ################################################################################

          {
            :label        => "モード",
            :key          => :xmode_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ::Swars::XmodeInfo.form_part_elems,
                :default => xmode_infos.collect(&:key),
              }
            },
          },

          {
            :label        => "開始モード",
            :key          => :imode_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ::Swars::ImodeInfo.form_part_elems,
                :default => imode_infos.collect(&:key),
              }
            },
          },

          {
            :label        => "持ち時間",
            :key          => :rule_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ::Swars::RuleInfo.form_part_elems,
                :default => rule_infos.collect(&:key),
              }
            },
          },

          {
            :label        => "手合割",
            :key          => :preset_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => PresetInfo.swars_preset_infos.inject({}) { |a, e| a.merge(e.key => e.to_form_elem) },
                :default => preset_infos.collect(&:key),
              }
            },
          },

          {
            :label        => "結末",
            :key          => :final_keys,
            :type         => :checkbox_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ::Swars::FinalInfo.form_part_elems,
                :default => final_infos.collect(&:key),
              }
            },
          },

          {
            :label        => "追加クエリ",
            :key          => :query,
            :type         => :string,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :default => query,
                :placeholder =>  "開戦:>=21 中盤:>=42 手数:>=89",
                :help_message => "棋譜検索と似た検索クエリを指定する。指定できるのは両対局者の共通の情報のみ。",
              }
            },
          },
          ################################################################################

          {
            :label        => "検索対象件数 直近X件",
            :key          => :range_size,
            :type         => :numeric,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :options      => { min: 10000, max: RANGE_SIZE_MAX, step: 10000 },
                :default      => range_size,
                :help_message => "この件数の中から抽出希望件数分の対局を探す。出てこないときはこの上限を増やそう。(#{RANGE_SIZE_THRESHOLD}件まではリアルタイム検索)",
              }
            },
          },
          {
            :label        => "抽出希望件数",
            :key          => :request_size,
            :type         => :numeric,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :options      => { min: 50, max: REQUEST_SIZE_MAX, step: 50 },
                :default => request_size,
                :help_message => "これだけ見つけたら検索を終える",
              }
            },
          },

          ################################################################################

          {
            :label        => "結果表示",
            :key          => :open_action_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => OpenActionInfo.form_part_elems,
                :default => open_action_info.key,
              }
            },
          },

          {
            :label        => "ZIPダウンロード",
            :key          => :download_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => DownloadInfo.form_part_elems,
                :default => download_info.key,
              }
            },
          },

          {
            :label        => "バックグラウンド実行",
            :key          => :bg_request_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => BgRequestInfo.form_part_elems,
                :default => bg_request_info.key,
              }
            },
          },

          {
            :label        => "ブックマーク用URLの生成",
            :key          => :bookmark_url_key,
            :type         => :radio_button,
            :session_sync => false,
            :dynamic_part => -> {
              {
                :elems           => BookmarkUrlInfo.form_part_elems,
                :default         => BookmarkUrlInfo[:off].key,
                :hidden_on_query => true,
              }
            },
          },
        ]
      end

      def top_content
        if request_get?
          MarkdownInfo.fetch("横断棋譜検索").to_box_content
        end
      end

      def call
        if running_in_foreground && (params[:exec].to_s == "true" || fetch_index >= 1)
          validate!
          if flash.present?
            return
          end
          if bookmark_url_info.key == :on
            flash[:notice] = "生成しました"
            return { _v_html: bookmark_html }
          end
          unless throttle.call
            flash[:notice] = "連打すな"
            return
          end
          if bg_request_info.key == :on
            params[:__bookmark_url__] = bookmark_url # バックグランドの場合は controller がないため、あらかじめ入れておく
            call_later
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
            redirect_to search_path, type: open_action_info.redirect_type
            return { _v_html: result_html }
          end
        end
        if running_in_background
          mail_notify
        end
      end

      def posted_message
        "承りました。終わったら #{current_user.email} あてに報告します。"
      end

      def validate!
        ################################################################################

        all_tag_names.each do |tag_name|
          unless Bioshogi::Analysis::TagIndex.lookup(tag_name)
            flash[:notice] = "#{tag_name}とはなんでしょう？"
            return
          end
        end

        all_user_keys.each do |user_key|
          unless ::Swars::User.exists?(key: user_key)
            flash[:notice] = "#{user_key} さんが見つかりません。ウォーズIDが間違っていませんか？"
            return
          end
        end

        ################################################################################

        if range_size > RANGE_SIZE_MAX
          flash[:notice] = "検索対象件数は#{RANGE_SIZE_MAX}件以下にしてください"
          return
        end
        if range_size > RANGE_SIZE_THRESHOLD
          if bg_request_info.key == :off
            flash[:notice] = "検索対象件数が#{RANGE_SIZE_THRESHOLD}件を越える場合はバックグラウンド実行してください"
            return
          end
        end

        ################################################################################

        if request_size > REQUEST_SIZE_MAX
          flash[:notice] = "抽出希望件数は#{REQUEST_SIZE_MAX}件以下にしてください"
          return
        end

        if params[:experiment]
          if request_size > REQUEST_SIZE_DEFAULT
            if download_info.key == :on && bg_request_info.key == :off
              flash[:notice] = "#{REQUEST_SIZE_DEFAULT}件を越える件数をZIPダウンロードする場合はバックグラウンド実行してください"
              return
            end
          end
        end

        ################################################################################

        # if x_judge_infos.present? && y_judge_infos.present?
        #   flash[:notice] = "「勝敗」と「相手の勝敗」は一方が決まれば一方が決まるので指定するのは片方だけでよいでしょう"
        #   return
        # end

        ################################################################################

        [
          { name: "勝敗",       model: ::JudgeInfo,                    infos: x_judge_infos, },
          # { name: "相手の勝敗", model: ::JudgeInfo,                  infos: y_judge_infos, },
          # ----
          { name: "モード",     model: ::Swars::XmodeInfo,             infos: xmode_infos,   },
          { name: "開始モード",   model: ::Swars::ImodeInfo,             infos: imode_infos,   },
          { name: "持ち時間",   model: ::Swars::RuleInfo,              infos: rule_infos,    },
          { name: "手合割",     model: PresetInfo.swars_preset_infos,  infos: preset_infos,  },
          { name: "結末",       model: ::Swars::FinalInfo,             infos: final_infos,   },
        ].each do |e|
          if (e[:model].collect(&:key) - e[:infos].collect(&:key)).empty?
            flash[:notice] = "#{e[:name]}の項目をすべて有効にするのは検索が遅くなるだけで意味がありません"
            return
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
        @processed_second = TimeTrial.second { found_ids }
        if download_info.key == :on
          download_content
        end
      end

      def found_ids
        @found_ids ||= yield_self do
          ids = []
          # FIXME: order(battled_at: :desc) としたいが実際は id: desc になっている
          ::Swars::Battle.in_batches(of: batch_size, order: :desc).each.with_index do |scope, batch_index|
            if batch_index >= batch_limit
              break
            end
            ids += sub_scope(scope).ids
            if ids.size >= request_size
              break
            end
          end
          ids.take(request_size)
        end
      end

      def sub_scope(scope)
        scope = battle_scope(scope)

        memberships = ::Swars::Membership.where(battle: scope.ids)

        x = memberships_scope_by(memberships, x_tag_names, x_tag_cond_info, x_judge_infos, x_location_infos, x_style_infos, x_grade_infos, x_user_keys, x_grade_diff_info)
        y = memberships_scope_by(memberships, y_tag_names, y_tag_cond_info,           nil,              nil, y_style_infos, y_grade_infos, y_user_keys,               nil)

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
            s = s.xmode_eq(v.collect(&:key))
          end
          if v = imode_infos.presence
            s = s.imode_eq(v.collect(&:key))
          end
          if v = rule_infos.presence
            s = s.rule_eq(v.collect(&:key))
          end
          if v = preset_infos.presence
            s = s.preset_eq(v.collect(&:key))
          end
          if v = final_infos.presence
            s = s.final_eq(v.collect(&:key))
          end
          s
        end
      end

      def memberships_scope_by(memberships, tag_names, tag_cond_info, judge_infos, location_infos, style_infos, grade_infos, user_keys, grade_diff_info)
        memberships.then do |s|
          if v = tag_names.presence
            s = s.tagged_with(v, tag_cond_info.tagged_with_options)
          end
          if v = judge_infos.presence
            s = s.judge_eq(v.collect(&:key))
          end
          if (v = location_infos.presence) && v.one?
            s = s.location_eq(v.collect(&:key))
          end
          if v = style_infos.presence
            s = s.style_eq(v.collect(&:key))
          end
          if v = grade_infos.presence
            s = s.grade_eq(v.collect(&:key))
          end
          if v = user_keys.presence
            s = s.where(user: ::Swars::User.where(key: v))
          end
          if info = grade_diff_info
            s = s.where(::Swars::Membership.arel_table[:grade_diff].public_send(info.comparison, info.value))
          end
          s
        end
      end

      ################################################################################

      def x_tag_names
        @x_tag_names ||= tag_string_split(params[:x_tags])
      end

      def y_tag_names
        @y_tag_names ||= tag_string_split(params[:y_tags])
      end

      def all_tag_names
        x_tag_names + y_tag_names
      end

      def tag_string_split(str)
        unless str.kind_of?(Array)
          str = StringToolkit.split(str.to_s)
        end
        str.uniq
      end

      def candidate_tag_names
        @candidate_tag_names ||= [:attack, :defense, :technique, :note].flat_map { |e| Bioshogi::Analysis::TacticInfo[e].model.collect(&:name) }
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

      def x_location_keys
        tag_string_split(params[:x_location_keys])
      end

      def x_location_infos
        @x_location_infos ||= LocationInfo.lookup_from_array(x_location_keys)
      end

      ################################################################################

      # def y_location_keys
      #   tag_string_split(params[:y_location_keys])
      # end
      #
      # def y_location_infos
      #   @y_location_infos ||= LocationInfo.lookup_from_array(y_location_keys)
      # end

      ################################################################################

      def x_judge_keys
        tag_string_split(params[:x_judge_keys])
      end

      def x_judge_infos
        @x_judge_infos ||= ::JudgeInfo.lookup_from_array(x_judge_keys)
      end

      ################################################################################

      # def y_judge_keys
      #   tag_string_split(params[:y_judge_keys])
      # end
      #
      # def y_judge_infos
      #   @y_judge_infos ||= ::JudgeInfo.lookup_from_array(y_judge_keys)
      # end

      ################################################################################

      def x_style_keys
        tag_string_split(params[:x_style_keys])
      end

      def x_style_infos
        @x_style_infos ||= ::Swars::StyleInfo.lookup_from_array(x_style_keys)
      end

      ################################################################################

      def y_style_keys
        tag_string_split(params[:y_style_keys])
      end

      def y_style_infos
        @y_style_infos ||= ::Swars::StyleInfo.lookup_from_array(y_style_keys)
      end

      ################################################################################

      def x_grade_keys
        tag_string_split(params[:x_grade_keys])
      end

      def x_grade_infos
        @x_grade_infos ||= ::Swars::GradeInfo.lookup_from_array(x_grade_keys)
      end

      ################################################################################

      def y_grade_keys
        tag_string_split(params[:y_grade_keys])
      end

      def y_grade_infos
        @y_grade_infos ||= ::Swars::GradeInfo.lookup_from_array(y_grade_keys)
      end

      ################################################################################

      def x_grade_diff_key
        GradeDiffInfo.lookup_key(params[:x_grade_diff_key])
      end

      def x_grade_diff_info
        @x_grade_diff_info ||= GradeDiffInfo.fetch_if(x_grade_diff_key)
      end

      ################################################################################

      def x_tags_cond_key
        TagCondInfo.lookup_key_or_first(params[:x_tags_cond_key])
      end

      def x_tag_cond_info
        @x_tag_cond_info ||= TagCondInfo.fetch(x_tags_cond_key)
      end

      ################################################################################

      def y_tags_cond_key
        TagCondInfo.lookup_key_or_first(params[:y_tags_cond_key])
      end

      def y_tag_cond_info
        @y_tag_cond_info ||= TagCondInfo.fetch(y_tags_cond_key)
      end

      ################################################################################ モード

      def xmode_keys
        tag_string_split(params[:xmode_keys])
      end

      def xmode_infos
        @xmode_infos ||= ::Swars::XmodeInfo.lookup_from_array(xmode_keys)
      end

      ################################################################################ 開始モード

      def imode_keys
        tag_string_split(params[:imode_keys])
      end

      def imode_infos
        @imode_infos ||= ::Swars::ImodeInfo.lookup_from_array(imode_keys)
      end

      ################################################################################ 持ち時間

      def rule_keys
        tag_string_split(params[:rule_keys])
      end

      def rule_infos
        @rule_infos ||= ::Swars::RuleInfo.lookup_from_array(rule_keys)
      end

      ################################################################################ 手合割

      def preset_keys
        tag_string_split(params[:preset_keys])
      end

      def preset_infos
        @preset_infos ||= PresetInfo.lookup_from_array(preset_keys)
      end

      ################################################################################ 結末

      def final_keys
        tag_string_split(params[:final_keys])
      end

      def final_infos
        @final_infos ||= ::Swars::FinalInfo.lookup_from_array(final_keys)
      end

      ################################################################################

      def request_size
        (params[:request_size].presence || REQUEST_SIZE_DEFAULT).to_i
      end

      def range_size
        (params[:range_size].presence || RANGE_SIZE_DEFAULT).to_i
      end

      ################################################################################

      def open_action_key
        OpenActionInfo.lookup_key_or_first(params[:open_action_key])
      end

      def open_action_info
        OpenActionInfo.fetch(open_action_key)
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

      def bookmark_url_key
        BookmarkUrlInfo.lookup_key_or_first(params[:bookmark_url_key])
      end

      def bookmark_url_info
        BookmarkUrlInfo.fetch(bookmark_url_key)
      end

      ################################################################################

      def query
        params[:query].to_s
      end

      ################################################################################

      def batch_size
        1000
      end

      def batch_limit
        @batch_limit ||= range_size.ceildiv(batch_size)
      end

      ################################################################################

      def foreground_execute_log
        AppLog.info(emoji: ":REALTIME:", subject: mail_subject, body: mail_body)
      end

      ################################################################################

      def empty_message
        out = []
        out << "ひとつも見つかりませんでした。"
        out << advice_message
        out.compact.join("\n")
      end

      # 抽出0件のときの条件修正アドバイス
      def advice_message
        # 強めの改善指示
        begin
          ################################################################################

          if x_tag_names.present? && x_style_infos.present?
            return "「自分のタグ」欄で具体的な戦法や囲いを指定している場合、その時点でスタイルがほぼ絞られているため、「自分のスタイル」の指定は外した方がいいかもしれません。"
          end
          if y_tag_names.present? && y_style_infos.present?
            return "「相手のタグ」欄で具体的な戦法や囲いを指定している場合、その時点でスタイルがほぼ絞られているため、「相手のスタイル」の指定は外した方がいいかもしれません。"
          end

          ################################################################################

          info = TagCondInfo.fetch(:and)
          if x_tag_names.many? && x_tag_cond_info == info
            return "「自分のタグの解釈」は「#{info}」で間違いありませんか？"
          end
          if y_tag_names.many? && y_tag_cond_info == info
            return "「相手のタグの解釈」は「#{info}」で間違いありませんか？"
          end

          ################################################################################

          if x_grade_diff_info.present? && y_grade_infos.present?
            return "「相手の棋力」と「相手の棋力(差)」の指定を一方だけにしてみてください。"
          end

          ################################################################################
        end

        # 弱めの改善指示
        begin
          if x_tag_names.present? && y_tag_names.present?
            return "「自分のタグ」欄だけを指定して他の条件を外してみてください。それでもマッチしない場合は「検索対象件数」を増やしてみてください。"
          end
        end

        # 「自分のタグ」だけを1件指定している場合は「将棋ウォーズ棋譜検索」で検索してほしいと伝える
        begin
          if x_tag_names.one? && y_tag_names.blank?
            return "「自分のタグ」に1件だけ指定している場合は「将棋ウォーズ棋譜検索」側で、そのタグだけを入力してみてください。ここよりたくさんヒットするはずです。"
          end
        end

        return "条件を緩めてください。それでもマッチしない場合は「検索対象件数」を増やしてみてください。"
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
            :bcc         => nil,
            :attachments => mail_attachments,
          }).deliver_now        # deliver_later では download_content のシリアライズの関係でエラーになる

        AppLog.info(subject: "#{mail_subject} (#{current_user.email})", body: mail_body)
      end

      def mail_attachments
        if download_info.key == :on
          { download_filename => download_content }
        end
      end

      def mail_subject
        "【横断棋譜検索】抽出#{found_ids.size}件"
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
        out << ""
        out << "▼再実行用URL (ブックマーク用URL)"
        out << bookmark_url
        out.join("\n")
      end

      def info
        {
          # -------------------------------------------------------------------------------- 対象
          "自分のタグ"           => x_tag_names,
          "自分のタグの解釈"     => x_tag_names.presence&.then { x_tag_cond_info.name },
          "自分の棋力"           => x_grade_infos.collect(&:name),
          "自分の勝敗"           => x_judge_infos.collect(&:name),
          "自分のスタイル"       => x_style_infos.collect(&:name),
          "自分のウォーズIDs"    => x_user_keys,
          # -------------------------------------------------------------------------------- 相手
          "相手のタグ"           => y_tag_names,
          "相手のタグの解釈"     => y_tag_names.presence&.then { y_tag_cond_info.name },
          "相手の棋力(差)"       => x_grade_diff_info&.name,
          "相手の棋力"           => y_grade_infos.collect(&:name),
          # "相手の勝敗"         => y_judge_infos.collect(&:name),
          "相手のスタイル"       => y_style_infos.collect(&:name),
          "相手のウォーズIDs"    => y_user_keys,
          # -------------------------------------------------------------------------------- バトルに対して
          "モード"               => xmode_infos.collect(&:name),
          "開始モード"           => imode_infos.collect(&:name),
          "持ち時間"             => rule_infos.collect(&:name),
          "手合割"               => preset_infos.collect(&:name),
          "結末"                 => final_infos.collect(&:name),
          "追加クエリ"         => query,
          # -------------------------------------------------------------------------------- フォーム
          "検索対象件数"         => range_size,
          "抽出希望件数"         => request_size,
          # -------------------------------------------------------------------------------- 受け取り方法
          "結果表示"             => open_action_info.name,
          "ZIPダウンロード"      => download_info.name,
          "バックグラウンド実行" => bg_request_info.name,
          # -------------------------------------------------------------------------------- 結果
          "抽出"                 => found_ids.size,
          # -------------------------------------------------------------------------------- 時間
          "実行開始"             => @processed_at.try { to_fs(:ymdhms) },
          "処理時間"             => @processed_second.try { ActiveSupport::Duration.build(self).inspect },
          # -------------------------------------------------------------------------------- 時間
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

      def bookmark_html
        "#{bookmark_link} ← これをブックマークしよう"
      end

      def bookmark_link
        h.tag.a("横断棋譜検索", href: bookmark_url, target: "_blank", :class => "tag is-primary")
      end

      def bookmark_url
        # バックグランドの場合は controller がないため、あらかじめ params[:__bookmark_url__] に入れておいたのを取り出す
        if v = params[:__bookmark_url__]
          return v
        end

        self.class.qs_url + "?" + bookmark_params.merge(bookmark_url_key: false, exec: true).to_query
      end

      def bookmark_params
        form_parts.inject({}) { |a, e| a.merge(e[:key] => controller.try { params[e[:key]] }) }
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
          processed_second = TimeTrial.second { io = zip_builder.to_blob }
          AppLog.info(subject: "ZIP生成 (#{found_ids.size})", body: ActiveSupport::Duration.build(processed_second).inspect)
          io
        end
      end

      ################################################################################
    end
  end
end

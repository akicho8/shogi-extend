module QuickScript
  module Swars
    class CrossSearchScript < Base
      prepend QueryMod

      self.title               = "将棋ウォーズ横断検索"
      self.description         = "ウォーズIDを指定しない検索"
      self.form_method         = :post
      self.button_label        = "実行"
      self.login_link_show     = true
      self.debug_mode          = Rails.env.local?
      self.throttle_expires_in = 5.0
      self.qs_invisible        = true

      MAX_OF_WANT_MAX      = 500    # 必要件数は N 以下
      BACKGROUND_THRESHOLD = 10000  # N以上ならバックグランド実行する
      MAX_OF_RANGE_MAX     = 50000  # 対象件数は N 以下

      def form_parts
        super + [
          {
            :label        => "戦法",
            :key          => :tag,
            :type         => :string,
            :ac_by        => :html5,
            :elems        => candidate_tag_names,
            :default      => params[:tag].presence,
            :help_message => "直接入力 or 右端の▼から選択する。この戦法が現われた対局で絞る。絞らなくてもいい。",
            :session_sync => true,
          },

          {
            :label        => "クエリ",
            :key          => :query,
            :type         => :string,
            :default      => params[:query].presence,
            :placeholder  => "ルール:10分 モード:野良 勝敗:勝ち 手数:>=80",
            :help_message => "必要なら将棋ウォーズ棋譜検索と似た検索クエリを指定する。ただしウォーズIDは指定できない。対局の条件のみで対局者一方の情報(たとえば先後)などは指定できない。",
            :session_sync => true,
          },

          ################################################################################

          {
            :label        => "必要件数",
            :key          => :want_max,
            :type         => :numeric,
            :options      => { min: 100, max: MAX_OF_WANT_MAX, step: 100 },
            :default      => want_max,
            :help_message => "この件数だけ見つけたら検索を終える",
            :session_sync => true,
          },
          {
            :label        => "検索対象件数 - 直近N件",
            :key          => :range_max,
            :type         => :numeric,
            :options      => { min: 10000, max: MAX_OF_RANGE_MAX, step: 10000 },
            :default      => range_max,
            :help_message => "この件数の中から必要件数分の対局を探す。抽出件数が足りないときはこの上限を増やす。",
            :session_sync => true,
          },

          ################################################################################

          {
            :label   => "バックグランド実行する",
            :key     => :bg_request,
            :type    => :radio_button,
            :elems   => {
              "false" => { el_label: "しない", el_message: "リアルタイムで結果を得る", },
              "true"  => { el_label: "する",   el_message: "あとでメールする",         },
            },
            :default => params[:bg_request].to_s.presence || "false",
            :session_sync => true,
          },
        ]
      end

      def call
        if foreground_mode
          if request_post?
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
              return { _autolink: posted_message }
            end
            if all_ids.empty?
              flash[:notice] = empty_message
              return
            end
            redirect_to search_path
          end
        end
        if background_mode
          mail_notify
        end
      end

      def current_bg_request
        params[:bg_request].to_s == "true"
      end

      def posted_message
        "終わったら #{current_user.email} あてに URL を送ります"
      end

      def validate!
        current_tag_names.each do |tag_name|
          unless Bioshogi::Explain::TacticInfo.flat_lookup(tag_name)
            flash[:notice] = "#{tag_name}とはなんでしょう？"
            return
          end
        end
        if want_max > MAX_OF_WANT_MAX
          flash[:notice] = "必要件数は#{MAX_OF_WANT_MAX}以下にしてください"
          return
        end
        if range_max > MAX_OF_RANGE_MAX
          flash[:notice] = "対象件数は#{MAX_OF_RANGE_MAX}以下にしてください"
          return
        end
        if range_max > BACKGROUND_THRESHOLD
          if !current_bg_request
            flash[:notice] = "#{BACKGROUND_THRESHOLD.next}件以上を対象するとき場合はバックグランド実行してください"
            return
          end
        end
        if current_bg_request
          unless current_user
            flash[:notice] = "バックグランド実行する場合は結果をメールするのでログインしてください"
            return
          end
          unless current_user.email_valid?
            flash[:notice] = "ちゃんとしたメールアドレスを登録してください"
            return
          end
        end
      end

      def all_ids
        @all_ids ||= yield_self do
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
        if current_tag_names.present?
          tag_scope = ::Swars::Membership.tagged_with(current_tag_names)
          if true
            # distinct を使う場合。こっちの方が 10 ms 速い。
            scope = scope.joins(:memberships).distinct.merge(tag_scope)
          else
            # distinct を使いたくないので再度 id で引く
            scope = scope.where(id: scope.joins(:memberships).merge(tag_scope).ids)
          end
        end
        scope = scope.find_all_by_params(query_info: query_info)
      end

      ################################################################################

      def current_tag_names
        @current_tag_names ||= params[:tag].to_s.split(/[,[:blank:]]+/).uniq
      end

      def candidate_tag_names
        @candidate_tag_names ||= [:attack, :defense, :technique, :note].flat_map { |e| Bioshogi::Explain::TacticInfo[e].model.collect(&:name) }
      end

      ################################################################################

      def query
        params[:query].to_s
      end

      def query_info
        @query_info ||= QueryInfo.parse(query)
      end

      ################################################################################

      def want_max
        (params[:want_max].presence || 100).to_i
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

      def mail_notify
        begin
          @processed_second = Benchmark.realtime { all_ids }
        end
        SystemMailer.notify({
            :emoji   => ":検索:",
            :subject => mail_subject,
            :body    => mail_body,
            :to      => current_user.email,
            :bcc     => AppConfig[:admin_email],
          }).deliver_now
      end

      def mail_subject
        [
          *current_tag_names.collect { |e| "[#{e}]" },
          "抽出#{all_ids.size}件",
        ].compact_blank.join(" ")
      end

      def mail_body
        out = []
        if all_ids.empty?
          out << empty_message
        else
          out << search_url
        end
        out << ""
        out << info.inspect
        out.join("\n")
      end

      def info
        {
          "タグ"     => current_tag_names,
          "クエリ"   => query,
          "抽出"     => all_ids.size,
          "必要"     => want_max,
          "対象"     => range_max,
          "処理時間" => @processed_second.try { ActiveSupport::Duration.build(self).inspect },
        }
      end

      def search_url
        UrlProxy.full_url_for(search_path)
      end

      def search_path
        query = "id:" + all_ids * ","
        "/swars/search" + "?" + { query: query }.to_query
      end

      def empty_message
        "ひとつも見つかりませんでした"
      end

      ################################################################################
    end
  end
end

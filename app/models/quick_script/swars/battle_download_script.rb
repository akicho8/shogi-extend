module QuickScript
  module Swars
    class BattleDownloadScript < Base
      self.title = "将棋ウォーズ棋譜ダウンロード"
      self.description = "指定ウォーズIDの棋譜をまとめてZIPでダウンロードする"
      self.form_method = :post
      self.button_label = "ダウンロード"
      self.login_link_show = true

      DEBUG_MODE = Rails.env.local?

      attr_accessor :processed_sec

      def form_parts
        super + [
          {
            :label        => "検索クエリ",
            :key          => :query,
            :type         => :string,
            :default      => query,
            :placeholder  => "BOUYATETSU5 勝敗:勝ち tag:右四間飛車",
            :help_message =
          },
          {
            :label       => "範囲",
            :key         => :scope_key,
            :type        => :radio_button,
            :elems       => ScopeInfo.to_form_elems(self),
            :default     => scope_info.key,
          },
          {
            :label       => "フォーマット",
            :key         => :format_key,
            :type        => :radio_button,
            :elems       => FormatInfo.to_form_elems,
            :default     => format_info.key,
          },
          {
            :label       => "文字コード",
            :key         => :encode_key,
            :type        => :radio_button,
            :elems       => EncodeInfo.to_form_elems,
            :default     => encode_info.key,
          },
          {
            :label       => "件数",
            :key         => :max_key,
            :type        => :radio_button,
            :elems       => MaxInfo.to_form_elems,
            :default     => max_info.key,
          },
          {
            :label       => "ZIPの構造",
            :key         => :structure_key,
            :type        => :radio_button,
            :elems       => StructureInfo.to_form_elems,
            :default     => structure_info.key,
          },
          {
            :label       => "バックグランド実行する",
            :key         => :bg_request,
            :type        => DEBUG_MODE ? :radio_button : :hidden,
            :elems       => {"false" => "しない", "true" => "する"},
            :default     => params[:bg_request].to_s.presence || (DEBUG_MODE ? "false" : "true"),
          },
        ]
      end

      def call
        if foreground_mode
          if request_get?
            if Rails.env.local?
              if current_user
                return "残りダウンロード可能件数: #{current_user.swars_zip_dl_logs.dl_rest_count} 件"
              end
            end
            return
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
            flash[:notice] = "ダウンロードを開始しました"
            redirect_to download_url, type: :hard
          end
        end
        if background_mode
          mail_notify
        end
      end

      def current_bg_request
        params[:bg_request].to_s == "true"
      end

      def swars_user_key_default
        @swars_user_key_default ||= yield_self do
          if DEBUG_MODE
            # ["BOUYATETSU5", "itoshinTV", "TOBE_CHAN"].sample
            ["BOUYATETSU5"].sample.collect { |e| UserKey[e] }
          end
        end
      end

      def long_title
        "#{swars_user.name_with_grade}の#{title}(#{scope_info.name}#{main_scope.size}件)"
      end

      def posted_message
        "できたら #{current_user.email} あてに#{main_scope.size}件の棋譜をZIPで送ります。数分かかる場合があります。"
      end

      def validate!
        unless current_user
          flash[:notice] = "ZIP をメールするのでログインしてください"
          return
        end
        unless current_user.email_valid?
          flash[:notice] = "ちゃんとしたメールアドレスを登録してください"
          return
        end
        if swars_user_key.blank?
          flash[:notice] = "将棋ウォーズIDを入力してください"
          return
        end
        unless swars_user
          flash[:notice] = "#{swars_user_key} は存在しません (一度棋譜検索すると出てくるかも)"
          return
        end
        if swars_user.battles.empty?
          flash[:notice] = "対局データがひとつもありません"
          return
        end
        if current_user.swars_zip_dl_logs.download_prohibit?
          flash[:notice] = current_user.swars_zip_dl_logs.error_message
          return
        end
        if main_scope.empty?
          flash[:notice] = scope_info.error_message
          return
        end
      end

      def to_zip
        @to_zip ||= yield_self do
          io = nil
          @processed_sec = Benchmark.realtime { io = zip_builder.to_blob }
          AppLog.important(subject: "将棋ウォーズ棋譜ダウンロード", body: summary)
          log_create!
          io
        end
      end

      def summary
        Summary.new(self).info.to_t
      end

      ################################################################################

      def mail_notify
        SystemMailer.notify({
            :subject     => long_title,
            :to          => current_user.email,
            :bcc         => AppConfig[:admin_email],
            :body        => "",
            :attachments => mail_attachments,
          }).deliver_now
      end

      def mail_attachments
        download_filename_cached
        { download_filename => download_content }
      end

      ################################################################################

      def render_format(format)
        super
        format.zip do
          download_filename_cached
          controller.send_data(download_content, {
              :type        => Mime["zip"],
              :filename    => download_filename,
              :disposition => "attachment",
            })
        end
      end

      # log_create! によってスコープが変化する前にメモ化でキャッシュしておく
      def download_filename
        @download_filename ||= FilenameBuilder.new(self).call
      end

      def download_filename_cached
        download_filename
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

      ################################################################################

      def log_create!(scope = main_scope)
        current_user.swars_zip_dl_logs.where(swars_user: swars_user).create_by_battles!(scope)
      end

      def swars_zip_dl_logs
        @swars_zip_dl_logs ||= current_user.swars_zip_dl_logs.where(swars_user: swars_user)
      end

      # 古い1件をダウンロードしたことにする
      def oldest_log_create
        scope = swars_user.battles.order(battled_at: :asc).limit(1)
        log_create!(scope)
      end

      ################################################################################

      def main_scope
        @main_scope ||= scope_info.scope[self, query_scope].limit(dl_rest_count)
      end

      def scope_info
        ScopeInfo.fetch(scope_key)
      end

      def scope_key
        params[:scope_key].presence || ScopeInfo.first.key
      end

      ################################################################################

      def encode_info
        EncodeInfo.fetch(encode_key)
      end

      def encode_key
        params[:encode_key].presence || EncodeInfo.first.key
      end

      ################################################################################

      def dl_rest_count
        @dl_rest_count ||= [current_user.swars_zip_dl_logs.dl_rest_count, max_info.value].min
      end

      def max_info
        MaxInfo.fetch(max_key)
      end

      def max_key
        params[:max_key].presence || MaxInfo.fetch(Rails.env.local? ? "1" : "100").key
      end

      ################################################################################

      def format_info
        FormatInfo.fetch(format_key)
      end

      def format_key
        params[:format_key].presence || FormatInfo.first.key
      end

      ################################################################################

      def structure_info
        StructureInfo.fetch(structure_key)
      end

      def structure_key
        params[:structure_key].presence || StructureInfo.first.key
      end

      ################################################################################

      def swars_user_key
        query_info.swars_user_key || (DEBUG_MODE ? swars_user_key_default : nil)
      end

      def swars_user
        @swars_user ||= swars_user_key.db_record
      end

      ################################################################################

      def query
        params[:query].to_s
      end

      def query_info
        @query_info ||= QueryInfo.parse(query)
      end

      def query_scope
        @query_scope ||= swars_user.battles.find_all_by_params(query_info: query_info, target_owner: swars_user)
      end

      ################################################################################
    end
  end
end

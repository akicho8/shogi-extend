module QuickScript
  module Swars
    class BattleDownloadScript < Base
      prepend QueryMod

      self.title               = "将棋ウォーズ棋譜ダウンロード"
      self.description         = "指定ウォーズIDの棋譜をまとめてZIPでダウンロードする"
      self.form_method         = :post
      self.button_label        = "ダウンロード"
      self.login_link_show     = true
      self.debug_mode          = Rails.env.local?
      self.throttle_expires_in = 5.0

      attr_accessor :processed_second

      def form_parts
        super + [
          form_part_for_query,
          {
            :label        => "範囲",
            :key          => :scope_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ScopeInfo.form_part_elems(self),
                :default => scope_info.key,
              }
            },
          },
          {
            :label        => "フォーマット",
            :key          => :format_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => FormatInfo.form_part_elems,
                :default => format_info.key,
              }
            },
          },
          {
            :label        => "文字コード",
            :key          => :encode_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => EncodeInfo.form_part_elems,
                :default => encode_info.key,
              }
            },
          },
          {
            :label        => "件数",
            :key          => :max_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems        => MaxInfo.form_part_elems,
                :default => max_info.key,
              }
            },
          },
          {
            :label        => "ZIPの構造",
            :key          => :structure_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems        => StructureInfo.form_part_elems,
                :default => structure_info.key,
              }
            },
          },
          {
            :label        => "バックグラウンド実行",
            :key          => :bg_request_key,
            :type         => debug_mode ? :radio_button : :hidden,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => BgRequestInfo.form_part_elems,
                :default => bg_request_key,
              }
            },
          },
        ]
      end

      def call
        if running_in_foreground
          # if debug_mode
          #   if current_user
          #     current_user.swars_zip_dl_logs.destroy_all
          #   end
          # end
          if request_get?
            self.body_position = :above
            return MarkdownInfo.fetch("棋譜ダウンロード").to_box_content
          end
          if request_post?
            validate!
            if flash.present?
              return
            end
            unless throttle.call
              flash[:notice] = "連打すな"
              return
            end
            if bg_request_info.key == :on
              call_later
              # self.form_method = nil # form をまるごと消す
              flash[:notice] = posted_message
              return
            end
            flash[:notice] = "ダウンロードを開始しました"
            redirect_to download_url, type: :hard
            return
          end
        end
        if running_in_background
          mail_notify
        end
      end

      def mail_subject
        "【将棋ウォーズ棋譜ダウンロード】#{query} (#{scope_info.name}#{main_scope.size}件)"
      end

      def posted_message
        "承りました。終わったら #{current_user.email} あてに#{main_scope.size}件の棋譜をZIPで送ります。"
      end

      def validate!
        unless current_user
          flash[:notice] = "ZIP をメールするのでログインしよう"
          return
        end

        unless current_user.email_valid?
          flash[:notice] = "ちゃんとしたメールアドレスを登録しよう"
          return
        end

        if swars_user_key
          if !swars_user
            flash[:notice] = "#{swars_user_key} は存在しません (一度棋譜検索すると出てくるかも)"
            return
          end
          if swars_user.battles.none?
            flash[:notice] = "対局データがひとつもありません"
            return
          end
        end

        # if current_user.swars_zip_dl_logs.download_prohibit?
        #   flash[:notice] = current_user.swars_zip_dl_logs.error_message
        #   return
        # end

        if main_scope.none?
          flash[:notice] = scope_info.error_message
          return
        end
      end

      def top_content
        if current_user
          h.tag.div(:class => "is-size-7") do
            "残りダウンロード可能件数: #{current_user.swars_zip_dl_logs.dl_rest_count} 件"
          end
        end
      end

      def to_zip
        @to_zip ||= yield_self do
          io = nil
          @processed_second = TimeTrial.second { io = zip_builder.to_blob }
          AppLog.info(subject: "将棋ウォーズ棋譜ダウンロード", body: summary)
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
            :emoji       => ":棋譜ZIP:",
            :subject     => mail_subject,
            :to          => current_user.email,
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
        current_user.swars_zip_dl_logs.create_by_battles!(scope, query: query)
      end

      def swars_zip_dl_logs
        current_user.swars_zip_dl_logs
      end

      # デバッグ用で対象ユーザーの一番古い棋譜を1件ダウンロードしたことにする
      # これによって「前回の続きから」が動作するようになる
      def one_record_download_for_debug
        if swars_zip_dl_logs.empty?
          one = swars_user.battles.order(battled_at: :asc).limit(1)
          swars_zip_dl_logs.create_by_battles!(one)
        end
      end

      ################################################################################

      def main_scope
        @main_scope ||= scope_info.scope.call(self, query_scope).limit(dl_rest_count)
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
        params[:max_key].presence || MaxInfo.fetch(Rails.env.local? ? "1" : "50").key
      end

      ################################################################################

      def format_info
        FormatInfo.fetch(format_key)
      end

      def format_key
        FormatInfo.lookup_key_or_first(params[:format_key])
      end

      ################################################################################

      def structure_key
        StructureInfo.lookup_key_or_first(params[:structure_key])
      end

      def structure_info
        StructureInfo.fetch(structure_key)
      end

      ################################################################################

      def bg_request_key
        BgRequestInfo.lookup_key(params[:bg_request_key], (debug_mode ? :off : :on))
      end

      def bg_request_info
        BgRequestInfo.fetch(bg_request_key)
      end

      ################################################################################
    end
  end
end

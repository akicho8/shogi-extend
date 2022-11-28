module Swars
  module ZipDl
    concern :ActionMethods do
      private

      def case_zip_download
        # あらかじめいろんなスコープでダウンロードできる数などを返す
        # GET http://localhost:3000/w.json?query=YamadaTaro&download_config_fetch=true
        if params[:download_config_fetch]
          if !current_user
            render json: {}, status: 401
            return
          end
          render json: main_builder
          return
        end

        if Rails.env.development? && current_user
          if params[:swars_zip_dl_logs_destroy_all]
            current_user.swars_zip_dl_logs.destroy_all
            return
          end
          if params[:oldest_log_create]
            main_builder.oldest_log_create
            return
          end
        end

        # 特定のスコープでダウンロードする
        # GET http://localhost:3000/w.zip?query=YamadaTaro
        if request.format.zip?
          if !current_user
            render plain: "ログインしてください", status: 401
            return
          end

          if main_builder.limiter.over?
            # main_builder.as_json[:limiter]
            slack_notify(subject: "ZIP-DL制限", body: current_user.name)
            render plain: main_builder.message, status: 404
            return
          end

          send_data(main_builder.to_zip.string, {
              :type        => Mime[params[:format]],
              :filename    => main_builder.zip_filename,
              :disposition => "attachment",
            })
        end
      end

      def main_builder
        @main_builder ||= yield_self do
          MainBuilder.new(params.to_unsafe_h.merge({
                :current_user        => current_user,
                :current_index_scope => sort_scope(current_index_scope),
                :swars_user          => current_swars_user,  # 対象ユーザー
              }))
        end
      end
    end
  end
end

require "kconv"

module Swars
  concern :ZipDlMethods do
    private

    def case_zip_download
      # あらかじめいろんなスコープでダウンロードできる数などを返す
      # GET http://localhost:3000/w.json?query=YamadaTaro&download_config_fetch=true
      if params[:download_config_fetch]
        if !current_user
          render json: {}, status: 401
          return
        end
        render json: zip_dl_cop.to_config
        return
      end

      if Rails.env.development? && current_user
        if params[:swars_zip_dl_logs_destroy_all]
          current_user.swars_zip_dl_logs.destroy_all
          return
        end
        if params[:oldest_log_create]
          zip_dl_cop.oldest_log_create
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

        if zip_dl_cop.dli_over?
          # zip_dl_cop.to_config[:dl_limit_info]
          slack_notify(subject: "ZIP-DL制限", body: current_user.name)
          render plain: zip_dl_cop.dli_message, status: 404
          return
        end

        send_data(zip_dl_cop.to_zip.string, type: Mime[params[:format]], filename: zip_dl_cop.zip_filename, disposition: "attachment")
      end
    end

    def zip_dl_cop
      @zip_dl_cop ||= yield_self do
        Swars::ZipDlCop.new(params.to_unsafe_h.merge({
              :current_user        => current_user,
              :current_index_scope => sort_scope(current_index_scope),
              :swars_user          => current_swars_user,  # 対象ユーザー
            }))
      end
    end
  end
end

require "kconv"

module Swars
  concern :ZipDlMod do
    private

    def zip_dl_perform
      # あらかじめいろんなスコープでダウンロードできる数などを返す
      # GET http://0.0.0.0:3000/w.json?query=Yamada_Taro&download_config_fetch=true
      if params[:download_config_fetch]
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
      # GET http://0.0.0.0:3000/w.zip?query=Yamada_Taro
      if request.format.zip?
        send_data(zip_dl_cop.zip_io.string, type: Mime[params[:format]], filename: zip_dl_cop.zip_filename, disposition: "attachment")
      end
    end

    def zip_dl_cop
      @zip_dl_cop ||= Swars::ZipDlCop.new(params.to_unsafe_h.merge({
            :current_user        => current_user,
            :current_index_scope => current_index_scope,
          }))
    end
  end
end
